# scripts

### [init_ubuntu.sh]
After installing ubuntu, then use this script to install vim, fish, tmux and github key.

### [install_opencv34.sh]
installation script for OpenCV 3.4.0 and its extra modules.
If ```DOWNLOADED=1``` is **uncommented**, it will assume that the installation files are already downloaded and uncompressed.

### [git_readme_example.md]
A template for git readme markdown file.

### [install_iptime_n500u_ubuntu.md]
Installation description for ipTIME n500u for Ubuntu.

### [create_animated_gif_from_sequence_imagemagic.sh]
With ImageMagic, create animated GIF file of image sequences under a directory. 

### [convert_images_of_2nd_ext_under_1st_dir_into_4th_ext_under_3rd_dir.sh]
For example, to convert "bmp" files of directory "dir_1" into "png" files and then save under the same structure of "dir_2", give the following command under the parent directory of "dir_1"
```
$ convert_images_of_2nd_ext_under_1st_dir_into_4th_ext_under_3rd_dir.sh dir_1 bmp dir_2 png
```
