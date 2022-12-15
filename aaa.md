## 1. First method (GNS3)

### FreeRADIUS server setup for GNS3

At first i tried to install FreeRADIUS server using [this link](https://computingforgeeks.com/how-to-install-freeradius-and-daloradius-on-ubuntu/). It appeared tp be successful but i couldn't figure out a way to connect a cisco router in GNS3 environment to this server. 

After this attempt i tried to go [this](https://github.com/kazkansouh/gns3-freeradius) route which was successful. These are the steps that I took:

1. Get the [freeraduis/freeradius-server](https://github.com/kazkansouh/gns3-freeradius/blob/master/freeradius.gns3a) image.
```
docker run -d freeradius/freeradius-server
```
2. Download the [appliance file](https://github.com/kazkansouh/gns3-freeradius/blob/master/freeradius.gns3a).
```
wget https://github.com/kazkansouh/gns3-freeradius/blob/master/freeradius.gns3a
```
3. Import the appliance file in GNS3.
(This step might be missing some of the prompts. Since I have already imported the appliance, some steps are skipped this time around.)

GNS3 -> File -> Import appliance -> Install the appliance on your local computer -> Next -> Finish.

### Using FreeRADIUS server in GNS3 (with cisco routers)

After setting up the FreeRADIUS server to work in GNS3 environment, it's time to specify the configurations of the server so that it can communicate with other network devices (routers in this instance) and perform it's tasks (Authentication, Authorization, Accounting in this instance). 

1. Start the server.

3. In the auxiliary console (right-click on the server and choose Auxiliary console or `telnet 127.0.0.1 {port}` (port is the number of the port that is assigned to the auxiliary console for this server. Can be determined usuing the first method, usually is the next port after the main console.)), you can see the configurations for the server. It behaves as a linux system since it is based on alpine. 

5. Go to the `/tc/raddb/clients.conf` file to add a client that is going to be getting some service from the FreeRADIUS server. Add the clinet to the end of the file.
``` bash
vi /etc/raddb/clients.conf
client R1 {
  ipv4addr = 192.168.1.1
  proto = udp 
  secret = pw
  nas_type = cisco
}
```
5. 
6. After specifying the server configurations, you need to stop and start the server for the changes to be written and take effect.
7. (optional) Use the main console to see reports of aaa activities and attribute values that are being sent and recieved by the server.

(There should be a way to connect a local FreeRADIUS server to GNS3 environment. To be explored further...)
