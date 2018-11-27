<!--- 
# Repo. of stereo camera calibration whose results are used as parameter files of the project "DroneVision / stereo_depth_and_detection"

# Order

### [save_stereo_images] -> [stereo_calib_eyedea] -> [get_rectified_stereo]
# [save_stereo_images]
#### 목적 : 
스테레오 캘리브레이션을 위해 스테레오 카메라오 부터 ** 체스보드가 적당히 잘 ** 보이는 왼쪽/오른쪽 이미지들을 저장하기 위함.
#### 빌드 :
-->
To install the driver of ipTIME n500u to Ubuntu, 
first download rtl8192du-master.zip in this repository.
```
$ unzip rtl8192du-master.zip
$ cd rtl8192du-master
$ sudo make clean
$ sudo make install
$ sudo modprobe 8192du
```  
<!--- 
#### 사용 예 :
See ``save_stereo_images.sh``<br/>
	
	$ ./save_stereo_images_exe -s_mm=24.95 -w=10 -h=7 -width=672 -height=376 -image_list=data/stereo_calib_khchoi.xml -show=1 -nr=1 -th_overlap=0.6 -sec_int=7 -dir_img=data
#### 인자들 :
-s_mm = chessboard grid side length in millimeters.<br/>
-w = # of horizontal grids<br/>
-h = # of vertical grids<br/>
-width = width of left or right camera image<br/>
-height = height of left or right camera image<br/>
-image_list = xml file name where image file names are listed.<br/>
-show = zero for not displaying, non-zero for display<br/>
-nr = short
-->
