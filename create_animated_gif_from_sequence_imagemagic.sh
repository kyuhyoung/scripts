# To make a animated gif file 'seq.gif' with time interval of 0.3 seconds between images and 2 loops from jpg files in the directory /data/images/
# -loop 0 means neverending loop.
convert -delay 30 -loop 2 /data/images/*.jpg seq.gif
