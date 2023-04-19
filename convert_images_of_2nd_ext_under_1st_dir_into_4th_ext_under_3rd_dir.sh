#!/bin/sh
# convert_images_of_2nd_ext_under_1st_dir_into_4th_ext_under_3rd_dir.sh hand_video_bmp bmp hand_video_png png
DIR_FROM=$1
EXT_FROM=$2
DIR_TO=$3
EXT_TO=$4
#sudo rsync -av --include='*/' hand_video_bmp/ hand_video_png/
sudo rsync -av --include='*/' ${DIR_FROM} ${DIR_TO}
#find . -type f -name '*.bmp' -execdir sh -c 'sudo convert "$0" -quality 100 "${0%.bmp}.png" && sudo rm "$0"' {} \;
find . -type f -name '*.${EXT_FROM}' -execdir sh -c 'sudo convert "$0" -quality 100 "${0%.${EXT_FROM}}.png" && sudo rm "$0"' {} \;
