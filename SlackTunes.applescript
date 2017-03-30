# config
property webhookURL : "your Slack WebHook URL here!"
property refreshRate : 5 # seconds
property borderColors : {"#6EC4D7", "#5AB992", "#E8A830"} # colours to use to left of post (picked at random)
property ssidList : {"ssid_1", "ssid_2"} # list of "office SSIDs" - only post to slack if attached to one of these. leave empty to always post to slack.

# globals
property userName : "SlackTunes"
property iTunesInstalled : false
property spotifyInstalled : false
property theTitleiTunes : "" # keep track of last played tracks in different apps separately, 
property theTitleSpotify : "" # so if playing in more than one app it doesn't constantly update slack
property checkSSID : true

# search/replace function lifted straight from from beaksandclaws version
on replace_chars(this_text, search_string, replacement_string)
	set AppleScript's text item delimiters to the search_string
	set the item_list to every text item of this_text
	set AppleScript's text item delimiters to the replacement_string
	set this_text to the item_list as string
	set AppleScript's text item delimiters to ""
	return this_text
end replace_chars

# set username (from system username)
set userName to do shell script "whoami"

# if no SSIDs listed, don't bother checking
if (count of ssidList) is equal to 0 then set checkSSID to false

# work out which apps are installed
tell application "Finder" to set iTunesInstalled to exists application file ((path to applications folder as string) & "iTunes")
tell application "Finder" to set spotifyInstalled to exists application file ((path to applications folder as string) & "Spotify")

# loopy
on idle
	
	# work out if user is "in the office"
	set inOffice to false
	if checkSSID is equal to false then
		set inOffice to true
	else
		# get current SSID and check against list
		set currentSSID to do shell script "/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'"
		repeat with thisSSID in ssidList
			if currentSSID as string is equal to thisSSID as string then set inOffice to true
		end repeat
	end if
	
	# if "in the office"
	if inOffice is equal to true then
		
		# iTunes
		if iTunesInstalled then
			if application "iTunes" is running then
				using terms from application "iTunes"
					tell application "iTunes"
						if player state is playing then
							set currentTrack to my replace_chars(current track's name, "\"", "\\\"")
							if (theTitleiTunes is equal to currentTrack) then
								return refreshRate
							else
								set theArtist to my replace_chars(current track's artist, "\"", "\\\"")
								set theTitleiTunes to currentTrack
								set theAlbum to my replace_chars(current track's album, "\"", "\\\"")
								set theColor to some item of borderColors
								do shell script "curl -X POST --data-urlencode 'payload={\"username\": \"" & userName & "\",  \"attachments\": [ {\"color\": \"" & theColor & "\", \"fallback\": \"" & my replace_chars(theTitleiTunes, "'", "\\u0027") & " - " & my replace_chars(theArtist, "'", "\\u0027") & "\", \"fields\": [ { \"value\": \"" & my replace_chars(theTitleiTunes, "'", "\\u0027") & " - " & my replace_chars(theArtist, "'", "\\u0027") & "\\n" & my replace_chars(theAlbum, "'", "\\u0027") & "\"  } ], \"footer\": \"via iTunes\" } ] }' " & webhookURL
							end if
						end if
					end tell
				end using terms from
			end if
		end if
		
		# Spotify
		if spotifyInstalled then
			if application "Spotify" is running then
				using terms from application "Spotify"
					tell application "Spotify"
						if player state is playing then
							set currentTrack to my replace_chars(current track's name, "\"", "\\\"")
							if (theTitleSpotify is equal to currentTrack) then
								return refreshRate
							else
								set theArtist to my replace_chars(current track's artist, "\"", "\\\"")
								set theTitleSpotify to currentTrack
								set theAlbum to my replace_chars(current track's album, "\"", "\\\"")
								set theArtwork to current track's artwork url
								set theUrl to current track's spotify url
								set theColor to some item of borderColors
								do shell script "curl -X POST --data-urlencode 'payload={\"username\": \"" & userName & "\",  \"attachments\": [ {\"color\": \"" & theColor & "\", \"fallback\": \"" & my replace_chars(theTitleSpotify, "'", "\\u0027") & " - " & my replace_chars(theArtist, "'", "\\u0027") & "\",  \"thumb_url\": \"" & theArtwork & "\", \"fields\": [ { \"value\": \"<" & theUrl & "|" & my replace_chars(theTitleSpotify, "'", "\\u0027") & "> - " & my replace_chars(theArtist, "'", "\\u0027") & "\\n" & my replace_chars(theAlbum, "'", "\\u0027") & "\" } ], \"footer\": \"via Spotify\" } ] }' " & webhookURL
							end if
						end if
					end tell
				end using terms from
			end if
		end if
		
	end if
	
	return refreshRate
	
end idle