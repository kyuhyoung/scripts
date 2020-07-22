# ssh 접속
# gedit
# 만약 gedit 창이 remote server에서 보여지면 아래를 실행하고 그렇지 않으면 보여질 때 까지 작업한다.
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth-n
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
chmod 777 $XAUTH
docker run -ti -e DISPLAY=$DISPLAY -v $XSOCK:$XSOCK -v $XAUTH:$XAUTH -e XAUTHORITY=$XAUTH --net host $1 /bin/bash
