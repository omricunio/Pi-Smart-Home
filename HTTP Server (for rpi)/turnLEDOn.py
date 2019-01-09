import RPi.GPIO as gpio

gpio.setmode(gpio.BCM)# bcm- port numbering
gpio.setup(17, gpio.OUT)# gpio pin 17- output

gpio.output(17, 1)# turn the pin on