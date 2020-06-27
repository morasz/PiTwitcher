#!/bin/bash
CONFIGURE_LED="configure_led.sh"
CONFIGURE_CAMERA="configure_camera.sh"

# Initialize for runtime
  source configure_led.sh
  source configure_camera.sh
  setLightState $ONAIR_LED $OFF

I=0
while true
do

    # get the current endpoint
    EPIDX=$(( $I % ${#ENDPOINTS[@]} ))
    CURENDPOINT=${ENDPOINTS[$EPIDX]}

    echo "Using $CURENDPOINT as twitch endpoint"

    # start the stream
    setLightState $ONAIR_LED $ON
    raspivid -t 0 -fps $VIDEOFPS -b $BITRATE -o - | \
        avconv -i - -vcodec copy -an \
            -r $CONVFRAMERATE \
            -g $CONVGOP \
            -bufsize $BITRATE \
            -pix_fmt $CONVPIXFORMAT \
            -f $CONVOUTFORMAT \
            "$CURENDPOINT/$STREAMKEY"

    # cooldown when stream was aborted
    setLightState $ONAIR_LED $OFF
    echo
    echo "Stream exited unexpected. Wait 60 seconds and restart..."
    echo

    sleep 60

    # jump to next endpoint
    I=$(( $I + 1 ))

done
