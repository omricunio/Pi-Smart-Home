from flask import Flask, session, request
import vlc
import urllib
#install flask and python-vlc using pip
import Database
import os
import json
import atexit
import turnAccessory
from omxplayer.player import OMXPlayer
import AccessorysPython
import time
import threading
import omxcontrol

os.system("fuser -k 5000/tcp") #free up the port
timeralreadyused=False
app = Flask(__name__)
app.secret_key = 'any random string'
p = vlc.MediaPlayer()
player = OMXPlayer("file.m4a")
player.quit()
q=False

AccessorysArray=[]
portsarr=AccessorysPython.getlistofallports()
print(portsarr)
for i in range(len(portsarr)):
    a=turnAccessory.TurnAccessory(int(portsarr[i]))
    AccessorysArray.append(a)

def turnallaccessorys(mybool):
    for i in range(len(AccessorysArray)):
        AccessorysArray[i].changestate(mybool)
turnallaccessorys(False)
@app.route('/turnall', methods = ['POST'])
def turnall():
    state=request.form.get("state")
    if(state=="on"):
        turnallaccessorys(True)
    elif(state=="off"):
        turnallaccessorys(False)
    return "true"


@app.route('/')
def hello_world():
    session['user']="admin"
    return "hello world"

@app.route('/addnewaccessory', methods = ['POST'])
def addnewaccessory():
    type=request.form.get("type")
    name = request.form.get("name")
    port = request.form.get("port")
    icon = request.form.get("icon")
    AccessorysPython.addnewaccessory(type,name,port,icon) #adds the accessory to the json file
    AccessorysArray.append(turnAccessory.TurnAccessory(int(port))) #adds the accessory to the current used devices
    return "true" #return true (success)

@app.route('/removeaccessory', methods = ['POST'])
def removeaccessory():
    id=request.form.get("id")
    AccessorysPython.removeitembyidnumber(id)
    return "true"

@app.route('/checkforport', methods = ['POST'])
def checkforport():
    port=request.form.get("port")
    print(port)
    if(AccessorysPython.searchforport(port)==True):
        return "false"
    return "true"

@app.route('/register',  methods = ['GET', 'POST'])
def register():
    if(request.method == 'GET'):
        s=request.query_string
        myLoginDB=Database.LoginDatabase()

        a=dict(item.split("=") for item in s.split("&"))

        myLoginDB.insert(a["username"],a["password"])
        myLoginDB.close()
        session["user"]="registered"
        return "true"

@app.route('/login',  methods = ['GET', 'POST'])
def login():
    if(request.method == 'GET'):
        s=request.query_string
        myLoginDB=Database.LoginDatabase()

        a=dict(item.split("=") for item in s.split("&"))

        exist=myLoginDB.exist(a["username"],a["password"])
        myLoginDB.close()
        session["user"]="login"
        print(exist)
        if(exist):
            return "true"
        else:
            return "false"

@app.route('/music',  methods = ['GET', 'POST'])
def music():
    if(request.method == 'GET'):
        s=request.query_string
        a=dict(item.split("=") for item in s.split("&"))
        songurl=a["songurl"]
        file = urllib.URLopener()
        file.retrieve(songurl, "file.m4a")

        #player = OMXPlayer("file.m4a")
        #player.stop()
        #instance = vlc.Instance()
        #global media
        #media = instance.media_new(songurl)
        #p.set_media(media)
        return "true"

@app.route('/musicactions',  methods = ['GET', 'POST'])
def musicactions():
    # if(request.method == 'GET'):
        s=request.query_string
        a=dict(item.split("=") for item in s.split("&"))
        action=a["action"]
        if(action=="stop"):
            global player
            global q
            if(q != True):
                print("QUIT")
                player.quit()
                q=True
        elif(action=="play"):
            global player
            q=False
            player = OMXPlayer("file.m4a")
            print(player)
        elif(action=="setvolume"):
            volume = float(a["volume"])
            try:
                player.unmute()
                if(volume>50):
                    player.set_volume(450*volume/100)
                elif(volume<50 and volume>0):
                    player.set_volume(-100/(volume/100))
                elif(volume==0):
                    player.mute()
            except: #Exception as OMXPlayerDeadError:
                print("No Player")
        return "true"

@app.route('/changeaccessorystate',  methods = ['GET', 'POST'])
def changeaccessorystate():
    # if(request.method == 'GET'):
        s=request.query_string
        a=dict(item.split("=") for item in s.split("&"))
        bol=a["state"]
        port=int(a["port"])

        for i in range(len(AccessorysArray)): #search for the port in the AccessorysArray
            current=AccessorysArray[i]
            if(current.port==port):
                if (bol == "true"):
                    current.changestate(True)
                elif (bol == "false"):
                    current.changestate(False)

        return "true"

@app.route('/accessorytimer',  methods = ['GET', 'POST'])
def accessorytimer():
    # if(request.method == 'GET'):
        s=request.query_string
        a=dict(item.split("=") for item in s.split("&"))
        t=int(a["time"])
        port=int(a["port"])

        for i in range(len(AccessorysArray)): #search for the port in the AccessorysArray
            current=AccessorysArray[i]
            if(current.port==port):
                break
        if(current):
            current.changestate(True)
            tr=threading.Timer(t,turnoffwrapper,[current])
            tr.start()
        return "true"

def turnoffwrapper(current):
    current.changestate(False)

@app.route('/info',  methods = ['GET', 'POST'])
def info():
    return session['user']

@app.route('/getaccessorys')
def getaccessorys():
    print(open("Accessorys.json").read())
    return open("Accessorys.json").read()

@app.route('/getaccessorysstatus')
def getaccessorysstatus():
    jsdict={}
    for i in range(len(AccessorysArray)):
        # obj=AccessorysArray[i]
        jsdict[obj.port]=obj.state
    # jsonobj=json.dumps(jsdict)
    return jsonobj

@app.route('/h')
def h():
    return "dd "+session['user']

def exitfunc():
    global player
    print(player)
    a.changestate(False)
    try:
        if(q==False):
            if(player.can_quit()):
                player.quit()
    except:
        print("No Player")

atexit.register(exitfunc)

if __name__ == '__main__':
   app.run(host='0.0.0.0')