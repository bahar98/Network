
en
sh version
dir
copy scp://{local-user}@{address-of-local-user(ip)}/{directory-of-the-image-on-the-local-machine}{image-name} disk0:[directory-to-copy-image-to(optional)]
#enter local user password
erase disk0:{image-name}.img

conf t
boot system disk0:{image-name}.img disk0:startup-config
sh version 
#still same version
reboot
#image changed 

