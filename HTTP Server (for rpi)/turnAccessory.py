import RPi.GPIO as gpio

class TurnAccessory:

    def __init__(self, port):
        gpio.setmode(gpio.BCM)  # bcm- port numbering
        gpio.setup(port, gpio.OUT)  # gpio pin output
        self.port = port
        self.state = False #turned off
        gpio.output(self.port, 0) #turns the accessory off

    def changestate(self, state):
        self.state=state
        if(state):
            gpio.output(self.port, 1)  # turns the pin on
        elif not(state):
            gpio.output(self.port, 0)  # turns the pin off

    def __str__(self):
        a={str(self.port): self.state}
        return a