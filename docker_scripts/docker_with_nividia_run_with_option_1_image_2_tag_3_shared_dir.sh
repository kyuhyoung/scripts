# First of all, install Nvidia-docker as in https://hiseon.me/linux/ubuntu/install-docker/
# For example,
# sh docker_with_nividia_run_with_option_1_image_2_tag_3_shared_dir mmdetection latest ~/data
# will call
# sudo docker run --gpus all -ti --shm-size 8G --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix. -v ~/data/:/mnt/data  mmdetection:latest
dir_shared="$(basename "$3")"
sudo docker run --gpus all -ti --shm-size 8G --rm --net=host -e QT_X11_NO_MITSHM=1 -e DISPLAY=$DISPLAY --device /dev/video0 -v /tmp/.X11-unix -v /dev/video0:/dev/video0 -v $3:/mnt/$dir_shared $1:$2 bash
