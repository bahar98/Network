## 1. First method (GNS3)

### FreeRADIUS server setup for GNS3

At first i tried to install FreeRADIUS server using [this link](https://computingforgeeks.com/how-to-install-freeradius-and-daloradius-on-ubuntu/). It appeared tp be successful but i couldn't figure out a way to connect a cisco router in GNS3 environment to this server. 

After this attempt i tried to go [this](https://github.com/kazkansouh/gns3-freeradius) route which was successful. These are the steps that I took:

1. Get the [freeraduis/freeradius-server](https://hub.docker.com/r/freeradius/freeradius-server) image.
```bash
docker run -d freeradius/freeradius-server
```
2. Download the [appliance file](https://github.com/kazkansouh/gns3-freeradius/blob/master/freeradius.gns3a).
```bash
wget https://github.com/kazkansouh/gns3-freeradius/blob/master/freeradius.gns3a
```
3. Import the appliance file in GNS3.
(This step might be missing some of the prompts. Since I have already imported the appliance, some steps are skipped this time around.)

GNS3 -> File -> Import appliance -> Install the appliance on your local computer -> Next -> Finish.

### Using FreeRADIUS server in GNS3 (with cisco routers)

After setting up the FreeRADIUS server to work in GNS3 environment, it's time to specify the configurations of the server so that it can communicate with other network devices (routers in this instance) and perform it's tasks (Authentication, Authorization, Accounting in this instance). 

1. Start the server.

2. In the auxiliary console (right-click on the server and choose Auxiliary console or `telnet 127.0.0.1 {port}` (port is the number of the port that is assigned to the auxiliary console for this server. Can be determined usuing the first method, usually is the next port after the main console.)), you can see the configurations for the server. It behaves as a linux system since it is based on alpine. 

3. Go to the `/etc/raddb/clients.conf` file to add a client that is going to be getting some service from the FreeRADIUS server (In this instance the client is the router that is connected to the server and is called nas in aaa. This router is the one that will be sending aaa requests to the server.) Add the clinet to the end of the file.
```bash
$ vi /etc/raddb/clients.conf
client R1 {
  ipv4addr = 192.168.1.1
  proto = udp 
  secret = pw
  nas_type = cisco
}
```
4. Go to the `/etc/raddb/users` file to add a user. This user is going to be used to authenticate a session on nas. Authorization and accounting services can also be configured for this user and nas. Add the users to the end of the file.
```bash
$ vi /etc/raddb/users
user1 Cleartext-Password := "123"
  Service-Type = Shell-User,
  Cisco-AVPair = "shell:priv-lvl=15"
user2 Cleartext-Password := "234"
  Service-Type = Login,
  Cisco-AVPair = "shell:priv-lvl=1"
user3 Cleartext-Password := "345"
  Service-Type = NAS-Prompt-User,
  Cisco-AVPair = "shell:priv-lvl=2"
```

5. Then go to the configuraton of the server (right-click -> configuration -> edit) and uncomment the lines related to the configuration of the interface of the server that is connected to the nas. It should look like this.
```bash
#
# This is a sample network config, please uncomment lines to configure the network
#

# Uncomment this line to load custom interface files
# source /etc/network/interfaces.d/*

# Static config for eth0
auto eth0
iface eth0 inet static
	address 192.168.1.2
	netmask 255.255.255.0
	gateway 192.168.1.1
	up echo nameserver 192.168.1.1 > /etc/resolv.conf

# DHCP config for eth0
#auto eth0
#iface eth0 inet dhcp
#	hostname freeradius

```
6. After specifying the server configurations, you need to stop and start the server for the changes to be written and take effect.
7. (optional) Use the main console to see reports of aaa activities and attribute values that are being sent and recieved by the server.

(There should be a way to connect a local FreeRADIUS server to GNS3 environment. To be explored further...)

## 2. Second method (Local)


When we have a physical router and we want to connect it to a radius server, this method is used.

I followed [this guide](https://hub.docker.com/r/freeradius/freeradius-server). Here I'm going to go into more detail for implementing this guide. Need to have docker installed.

1. Create a directory to work in.
```bash
mkdir radius-local
cd radius-local
```
2. Get the [freeradius/freeradius-server](https://hub.docker.com/r/freeradius/freeradius-server) image.
```bash
$ docker run --name my-radius -d freeradius/freeradius-server
```
3. Create a `Dockerfile` in the working directory.
```bash
touch Dockerfile
```
4. Copy the server configuration into the Dockerfile.
```bash
nano Dockerfile
FROM freeradius/freeradius-server:latest
COPY raddb/ /etc/raddb/
```
5. Create the directories and files below in your working directory.
```bash
mkdir raddb
cd raddb
mkdir mods-config
touch clients.conf
cd mods-config
mkdir files
cd files
touch authorize
```
Your working directory should look like this.
```
clients.conf
mods-config/
mods-config/files/
mods-config/files/authorize
```
6. Add test client and user.
















Special Thanks to: [MAR-Coding](https://github.com/mar-coding)
