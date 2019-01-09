import turnLED
import time
a=turnLED.TurnLED(17)
a.changestate(True)
time.sleep(3)
a.changestate(False)