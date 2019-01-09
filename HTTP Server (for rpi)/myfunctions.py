def string2bool(str):
    if(str == "True"):
        return True
    elif(str == "False"):
        return False
    return
def getmyip(way):
    import socket
    import fcntl
    import struct

    def get_ip_address(ifname):
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        return socket.inet_ntoa(fcntl.ioctl(
            s.fileno(),
            0x8915,  # SIOCGIFADDR
            struct.pack('256s', ifname[:15])
        )[20:24])

    return get_ip_address(way)
