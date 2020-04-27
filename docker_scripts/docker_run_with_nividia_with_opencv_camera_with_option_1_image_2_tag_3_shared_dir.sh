# First of all, install Nvidia-docker as in https://hiseon.me/linux/ubuntu/install-docker/
# Then type
# $ xauth list
# The return might be as followings :
# visionking/unix:12  MIT-MAGIC-COOKIE-1  d04060f052faab8a805637da30dbbd61        
# visionking/unix:13  MIT-MAGIC-COOKIE-1  b4b596ec1d49771b5262ebdb9b0e6599         
# visionking/unix:14  MIT-MAGIC-COOKIE-1  81fb5fbefa0fc8ffec8e7379204895be          
# visionking/unix:0  MIT-MAGIC-COOKIE-1  2150216277d8307bb93d409800ad18a4       
# visionking/unix:10  MIT-MAGIC-COOKIE-1  c64df63afbc9650fac8840aaf9a1c684   
# visionking/unix:11  MIT-MAGIC-COOKIE-1  ab8cc4949d7e4ea7c3d383d5ad398b67      
# Create container by  
# $ sh docker_with_nividia_run_with_option_1_image_2_tag_3_shared_dir mmdetection latest ~/data
# This will call
# sudo docker run --gpus all -ti --shm-size 8G --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix. -v ~/data/:/mnt/data  mmdetection:latest
dir_shared="$(basename "$3")"
sudo docker run --gpus all -ti --shm-size 8G --rm --net=host -e QT_X11_NO_MITSHM=1 -e DISPLAY=$DISPLAY --device /dev/video0 -v /tmp/.X11-unix -v /dev/video0:/dev/video0 -v $3:/mnt/$dir_shared $1:$2 bash
# In container,
# $ apt-get update
# Install xauth
# $ apt-get install xauth
# Add the results of "xauth list" as following.
# $ xauth add visionking/unix:12  MIT-MAGIC-COOKIE-1  d04060f052faab8a805637da30dbbd61
# $ xauth add visionking/unix:13  MIT-MAGIC-COOKIE-1  b4b596ec1d49771b5262ebdb9b0e6599
# $ xauth add visionking/unix:14  MIT-MAGIC-COOKIE-1  81fb5fbefa0fc8ffec8e7379204895be          
# $ xauth add visionking/unix:0  MIT-MAGIC-COOKIE-1  2150216277d8307bb93d409800ad18a4       
# $ xauth add visionking/unix:10  MIT-MAGIC-COOKIE-1  c64df63afbc9650fac8840aaf9a1c684   
# $ xauth add visionking/unix:11  MIT-MAGIC-COOKIE-1  ab8cc4949d7e4ea7c3d383d5ad398b67
# Run opencv application using webcam.
