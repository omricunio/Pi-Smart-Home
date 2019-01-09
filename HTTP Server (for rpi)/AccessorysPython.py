import json

def getfullitem(i):
    file = open("Accessorys.json")
    data = json.load(file)
    file.close()
    return data["Acessorys"][i]

def getlistofallports(): #returns list of all the ports
    file = open("Accessorys.json")
    data = json.load(file)
    file.close()
    arr=[]
    for i in range(len(data["Accessorys"])):
        arr.append(data["Accessorys"][i]["port"])
    return arr

def getattributeforitem(id, attribute):
    file = open("Accessorys.json")
    data = json.load(file)
    file.close()
    for i in range(len(data["Accessorys"])):
        if(str(id)==data["Accessorys"][i]["id"]):
            return data["Accessorys"][i][attribute]
    return "no"

def searchforport(port):
    file = open("Accessorys.json")
    data = json.load(file)
    file.close()
    for i in range(len(data["Accessorys"])):
        if(str(port)==data["Accessorys"][i]["port"]):
            return True
    return False

def removeitembyidnumber(id):
    file = open("Accessorys.json","r")
    data = json.load(file)
    file.close()
    file = open("Accessorys.json","w")
    for i in range(len(data["Accessorys"])):
        if(str(id)==data["Accessorys"][i]["id"]):
            print data["Accessorys"][i]["id"]
            del data["Accessorys"][i]
            break
    json.dump(data,file)
    file.close()

def getportnumberforid(id):
    return getattributeforitem(id,"port")

def getallitems():
    file = open("Accessorys.json")
    data = json.load(file)
    file.close()
    return data


def addnewaccessory(type, name, port, icon):
    file = open("Accessorys.json")
    odata = json.load(file)
    data = odata["Accessorys"]
    file.close()
    file = open("Accessorys.json", "w")
    newdata = {
        "id": str(odata["numofitems"]),
        "type": type,
        "name": name,
        "port": port,
        "icon": icon
    }
    odata["numofitems"]=str(int(odata["numofitems"])+1)
    data.append(newdata)
    json.dump(odata, file)
    file.close()


