# SlackTunes
A simple AppleScript solution to post "now playing" data to our office Slack.
This is a bit hacky and very specific to our office setup, but a number of people asked for it, so here it is. Perhaps you can help improve it?  ;)

![demo image](https://github.com/blucube/SlackTunes/raw/master/demo.png)

## Intro
A bunch of us share an office. We listen to music through an Airport Express connected to a stereo. At any time, one of us is playing music from our Mac, either from iTunes (and AirPlay) or Spotify (and Airfoil).
We wanted a way of knowing what was playing. [Jon](http://www.hicksdesign.co.uk/) found [this solution](https://github.com/beaksandclaws/current-song-to-slack) which worked but I wanted to expand on it. Would have been easier if I knew anything about AppleScript, but hey ho.

## How it works
When running the application, while on the "office network" (to avoid accidental announcement of your love of The Bieber when you're listening to music at home) and listening to music on iTunes or Spotify, the details of each track will be posted to the Slack channel.

Music played through Spotify gets more detail than iTunes (link to track and album artwork).

## Using SlackTunes
* Set up a new WebHooks integration for Slack and get the URL for it
* Change the config variables at the top of the script
* Compile the script (hint - "Stay open after run handler" is your friend)
* Run the application

## To do
* Currently, if someone is running the application, in the office, and listens to something on headphones (or in any way not through the office stereo) this IS posted to Slack. This could be avoided by testing if Airfoil is running and active, or if iTunes is playing through AirPlay.
* iTunes album artwork. That would be nice eh?
* Someone cleverer than me needs to check what "media kind" the currently playing iTunes track is, and omit incompatible types. For example, if anyone plays a radio station at the moment the Internet explodes.

## Thanks
Thanks to [Kellen Hawley](https://github.com/beaksandclaws) for the original script which I've borrowed heavily from, and to m'colleague [Jon Hicks](http://www.hicksdesign.co.uk/) for the icons.
