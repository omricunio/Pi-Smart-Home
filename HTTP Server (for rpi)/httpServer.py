#!/usr/bin/python
import urlparse
import turnLED
import myfunctions
import socket
from BaseHTTPServer import BaseHTTPRequestHandler,HTTPServer

class myHandler(BaseHTTPRequestHandler):
    def do_GET(self):  # Action
        #print (self.path)  # After the address

        parsed_path = urlparse.urlparse(self.path)
        print(parsed_path)
        try:
            params = dict([p.split('=') for p in parsed_path[4].split('&')]) # Split it (makes it dict)
            #print(params)
        except:
            params = {}

        self.send_response(200)  # Succeed
        self.send_header('Content-type','text/html') # HTTP header
        self.end_headers()
        self.wfile.write("<h1><Center>Hello "+params["r"]+" from HTTP server (Omri_Cunio)")
        bol = myfunctions.string2bool(params["r"])
        print(bol)
        obj.changestate(bol)
        self.wfile.write(" ENJOY!</Center></h1>")
        self.wfile.write('<Center><iframe width="560" height="315" src="https://www.youtube.com/embed/CwLGro-dFWg"></iframe></Center>')
        self.wfile.write("<Center>"
                         "  <Table border='1' width='100%'  style='font-size:250%'>"
                         "      <tr>"
                         "          <td style='background-color:green' height='250'>"
                         "              <a href='http://"+theip+":8080/?r=True'>Turn ON LED"
                         "              </a>"
                         "          </td>"
                         "          <td style='background-color:red' height='250'>"
                         "              <a href='http://"+theip+":8080/?r=False'>Turn OFF LED"
                         "              </a>"
                         "          </td>"
                         "      </tr>"
                         "  </Table>"
                         "</Center>")
        return

try:
    server = HTTPServer(('', 8080), myHandler)  # Turns the server on
    print 'HTTPServer started'
    print("Ho Ya!")
    theip=myfunctions.getmyip("wlan0")
    print(myfunctions.getmyip("wlan0"))
    obj = turnLED.TurnLED(17)
    server.serve_forever()

except KeyboardInterrupt:
    print 'server.socket.close()'  # Closes the server
    server.socket.close()