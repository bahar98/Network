## 1. First method used (gns3)

#### FreeRADIUS server setup for GNS3

At first i tried to install FreeRadius server using [this link](https://computingforgeeks.com/how-to-install-freeradius-and-daloradius-on-ubuntu/). It appeared tp be successful but i couldn't figure out a way to connect a cisco router in GNS3 environment to this server. 

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
(This step might be missing some configurations.Since I have already imported the appliance, some steps are skipped this time around.)

GNS3 -> File -> Import appliance -> Install the appliance on your local computer -> Next -> Finish.

#### Using FreeRADIUS server in GNS3 (with cisco routers)

