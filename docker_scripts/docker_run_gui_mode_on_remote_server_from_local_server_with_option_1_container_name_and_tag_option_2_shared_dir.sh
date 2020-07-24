IMAGE_AND_TAG=$1
SHARED_DIR_HOST=$2
SHARED_DIR_CONTAINER=`basename "$SHARED_DIR_HOST"`
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth-n
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
chmod 777 $XAUTH
#docker run -ti -e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH --net host $1 /bin/bash
docker run -ti --gpus all --rm --privileged -e DISPLAY=$DISPLAY -v $SHARED_DIR_HOST:/root/$SHARED_DIR_CONTAINER -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH --net host $IMAGE_AND_TAG /bin/bash -c "apt-get update; apt-get install fish gedit -y; (gedit &); fish"
#docker run -ti --gpus all --rm --privileged -e DISPLAY=$DISPLAY -v $SHARED_DIR_HOST:/root/$SHARED_DIR_CONTAINER -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH --net host $IMAGE_AND_TAG /bin/bash -c "apt-get update; apt-get install fish gedit -y; (gedit &); killall -9 gedit; fish"
