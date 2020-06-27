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
