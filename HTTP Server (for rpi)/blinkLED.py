import RPi.GPIO as gpio
import time

gpio.setmode(gpio.BCM)# bcm- port numbering
gpio.setup(17, gpio.OUT)# gpio pin 17- output
x=float(raw_input("Insert"))
while True:
    gpio.output(17, 1)# turn the pin on
    time.sleep(x)# sleep 0.25s
    gpio.output(17, 0)# turn the pin off
    time.sleep(x)#sleep 0.25s
