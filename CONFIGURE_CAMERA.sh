#!/bin/bash
# Lookup your rtmp-Servers based on your location on https://stream.twitch.tv/ingests/

# Twitch Settings
  # Enter your STREAMKEY
    STREAMKEY=live_XXXXXXXXX_YYYYYYYYYYYYYYYYYYYYYYYYYYYYY
  # Enter your RTMP-Servers found for your location
    ENDPOINTS=(rtmp://live-fra.twitch.tv/app rtmp://live-ber.twitch.tv/app rtmp://live-ams.twitch.tv/app)
  # Setting up video stream settings
    VIDEOFPS=25
    BITRATE=2000000
    CONVFRAMERATE=30
    CONVGOP=30
    CONVPIXFORMAT=yuv420p
    CONVOUTFORMAT=flv
