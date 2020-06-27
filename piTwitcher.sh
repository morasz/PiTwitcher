#!/bin/bash

# Setting up an ONAIR_LED
  # Common path for all GPIO access
  BASE_GPIO_PATH=/sys/class/gpio

  # Assign name to GPIO pin number for LED
  ONAIR_LED = 23

  # Assign names to valid states
  ON="1"
  OFF="0"

# Setting up utility functions to use the GPIO pin
  # Utility function to export a pin if not already exported
  exportPin(){
    if [ ! -e $BASE_GPIO_PATH/gpio$1 ]; then
      echo "$1" > $BASE_GPIO_PATH/export
    fi
  }

  # Utility function to set a pin as an output
  setOutput(){
    echo "out" > $BASE_GPIO_PATH/gpio$1/direction
  }

  # Utility function to change state of LED
  setLightState(){
    echo $2 > $BASE_GPIO_PATH/gpio$1/value
  }

  # Ctrl-C handler for clean shutdown
  shutdown(){
    setLightState $ONAIR_LED $OFF
    exit 0
  }

trap shutdown SIGINT

# Initialize LED for runtime
  # Export pins so that we can use them
    exportPin $ONAIR_LED
  # Set pins as outputs
    setOutput $ONAIR_LED
  # Turn LED off initially
    setLightState $ONAIR_LED $OFF

# https://stream.twitch.tv/ingests/

# twitch settings
STREAMKEY=live_XXXXXXXXX_YYYYYYYYYYYYYYYYYYYYYYYYYYYYY
ENDPOINTS=(rtmp://live-fra.twitch.tv/app rtmp://live-ber.twitch.tv/app rtmp://live-ams.twitch.tv/app)

# stream settings
VIDEOFPS=25
BITRATE=2000000
CONVFRAMERATE=30
CONVGOP=30
CONVPIXFORMAT=yuv420p
CONVOUTFORMAT=flv

I=0
while true
do

    # get the current endpoint
    EPIDX=$(( $I % ${#ENDPOINTS[@]} ))
    CURENDPOINT=${ENDPOINTS[$EPIDX]}

    echo "Using $CURENDPOINT as twitch endpoint"

    # start the stream
    raspivid -t 0 -fps $VIDEOFPS -b $BITRATE -o - | \
        avconv -i - -vcodec copy -an \
            -r $CONVFRAMERATE \
            -g $CONVGOP \
            -bufsize $BITRATE \
            -pix_fmt $CONVPIXFORMAT \
            -f $CONVOUTFORMAT \
            "$CURENDPOINT/$STREAMKEY"

    # cooldown when stream was aborted
    echo
    echo "Stream exited unexpected. Wait 60 seconds and restart..."
    echo

    sleep 60

    # jump to next endpoint
    I=$(( $I + 1 ))

done
