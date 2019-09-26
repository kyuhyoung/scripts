# When the result of "lsusb" is as following
# $ lsusb
# $ Bus 003 Device 013: ID 046d:082d Logitech, Inc. HD Pro Webcam C920
# Type as follows to get the list of available camera resolutions. 
lsusb -s 003:013 -v | egrep "Width|Height"
