# ssh 접속
# gedit
# 만약 gedit 창이 remote server에서 보여지면 아래를 실행하고 그렇지 않으면 보여질 때 까지 작업한다.
# usage : $ sh docker_run_gui_mode_on_remote_server_from_local_server_with_option_1_container_name_and_tag_option_2_shared_dir.sh my_image:my_tag /path/to/shared_dir
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
