import RPi.GPIO as gpio
import socket

gpio.setmode(gpio.BCM)# bcm- port numbering
gpio.setup(17, gpio.OUT)# gpio pin 17- output

server_socket=socket.socket()
server_socket.bind(('10.0.0.48',8820))
server_socket.listen(1)#one each time

(client_socket, client_address)=server_socket.accept()#wait...

p=client_socket.recv(1024)
if(p==1):
    gpio.output(17, 1)
elif(p==0):
    gpio.output(17, 0)
