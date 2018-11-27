# Repo. of stereo camera calibration whose results are used as parameter files of the project "DroneVision / stereo_depth_and_detection"

# Order

### [save_stereo_images] -> [stereo_calib_eyedea] -> [get_rectified_stereo]

# [save_stereo_images]
#### ���� : 
���׷��� Ķ���극�̼��� ���� ���׷��� ī�޶�� ���� ** ü�����尡 ������ �� ** ���̴� ����/������ �̹������� �����ϱ� ����.
#### ���� :
	$ make -f Makefile_save_stereo_images
#### ��� �� :
See ``save_stereo_images.sh``<br/>
	
	$ ./save_stereo_images_exe -s_mm=24.95 -w=10 -h=7 -width=672 -height=376 -image_list=data/stereo_calib_khchoi.xml -show=1 -nr=1 -th_overlap=0.6 -sec_int=7 -dir_img=data
#### ���ڵ� :
-s_mm = chessboard grid side length in millimeters.<br/>
-w = # of horizontal grids<br/>
-h = # of vertical grids<br/>
-width = width of left or right camera image<br/>
-height = height of left or right camera image<br/>
-image_list = xml file name where image file names are listed.<br/>
-show = zero for not displaying, non-zero for display<br/>
-nr = short for no-rectification<br/>
-th_overlap = area raitio threshold for overlap check<br/>
-sec_int = seconds for the idle time for next capture<br/>
-dir_img = folder to save the captured images. <br/>   

# [stereo_calib_eyedea]
#### ���� : 
����� ����/������ �̹��� �ֵ�� ���� ���׷��� Ķ���극�̼��� �����Ͽ� intrinsic / extrinsic paramter ���� ���ϰ� �̸� yml ���Ϸ� ������.
#### ���� :
	$ make -f Makefile_stereo_calib
#### ��� �� :
See ``stereo_calib_eyedea.sh``<br/>
	
	$ ./stereo_calib_eyedea_exe -s=24.95 -w=10 -h=7 -dir=data/zed_672x376/ -e=10,8 -input=data/stereo_calib_khchoi.xml
#### ���ڵ� :
-s = length of the side of the chessboard square in millimeters.<br/> 
-w = # of grid in horizontal side. <br/>
-h = # of grid in vertical side.  <br/>
-e = list of one-based indices to skip.<br/>
-dir = folder where the actual image files are.<br/>
-input = path to the xml file in which image file names are listed.<br/>

# [get_rectified_stereo]
#### ���� : 
Ķ���극�̼� ��� �Ķ���� ���ϵ�(����/������ intrinsic parameter���� yml ���ϰ�, extrinsic paramter���� yml ����)�� ���� ������ ����/������ �̹��� �ֵ鿡 ���� rectified�� �̹������� ���ϰ� ������.
#### ���� :
	$ make -f Makefile_get_rectified_stereo
#### ��� �� :
See ``get_rectified_stereo.sh``<br/>
	
	$ ./get_rectified_stereo_exe -int=data/zed_672x376/intrinsics.yml -ext=data/zed_672x376/extrinsics.yml -post=alfa_1 -input=data/stereo_calib_khchoi.xml -dir=data/zed_672x376/ -sec=1 -alfa=1
#### ���ڵ� :
-int = path to the left/right intrinsic parameter file <br/>
-ext = path to the extrinsic parameter file <br/>
-alfa = [0 ~ 1 or -1]. The scale factor for undistortion and rectification. Check the following post for the effect ( http://support.eyedea.co.kr:8200/browse/VIS-8?focusedCommentId=19304&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-19304 ) <br/>
-post = postfix for the resulted yml file name. <br/>
-input = path to the xml file where the left and right images are listed. <br/>
-dir = the directory where the resulted rectifed images are supposed to be saved. <br/>
-sec = display interval in seconds. <br/>

# All in sequence
#### ��� �� :
See ``all_in_sequence.sh``<br/>
```	
CAMERA=ocams
WIDTH=640
HEIGHT=480
SQUARE_MM=24.95
WIDTH_CHESS=10
HEIGHT_CHESS=7
CALIB_ENV=$CAMERA_$WIDTHx$HEIGHT_$WIDTH_CHESSx$HEIGHT_CHESS_$SQUARE_MM
CAM_IDX=1
IMAGE_XML=data/stereo_calib_$CALIB_ENV.xml
DIR=data/$CALIB_ENV/
ALPHA=0
./save_stereo_images_exe -cam=$CAMERA -ci=$CAM_IDX -s_mm=$SQUARE_MM -w=$WIDTH_CHESS -h=$HEIGHT_CHESS -width=$WIDTH -height=$HEIGHT -image_list=$IMAGE_XML -dir_img=$DIR -show=1 -nr=1 -th_overlap=0.6 -sec_int=7; 
./stereo_calib_eyedea_exe -s=$SQUARE_MM -w=$WIDTH_CHESS -h=$HEIGHT_CHESS -dir_img=$DIR -dir_calib=$DIR -input=$IMAGE_XML
./get_rectified_stereo_exe -input=$IMAGE_XML -int=$DIR/intrinsics.yml -ext=$DIR/extrinsics.yml -alfa=$ALPHA -post=alfa_$ALPHA -sec=1 -dir=rectified_result

```
#### ���ڵ� :
CAMERA = currently one of [zed, ocams] <br/>
WIDTH = width of left or right camera image <br/>
HEIGHT = width of left or right camera image <br/>
SQUARE_MM = chessboard grid side length in millimeters. <br/>
WIDTH_CHESS = # of grid in horizontal side of chessboard. <br/>
HEIGHT_CHESS = # of grid in vertical side of chessboard. <br/>
CAM_IDX = camera index. <br/>
IMAGE_XML = path to xml file where image file names are listed <br/>
DIR = folder where actual left/right image and calibration parameter files are saved. <br/> 
ALPHA = [0 ~ 1 or -1]. The scale factor for undistortion and rectification. Check the following post for the effect ( http://support.eyedea.co.kr:8200/browse/VIS-8?focusedCommentId=19304&page=com.atlassian.jira.plugin.system.issuetabpanels:comment-tabpanel#comment-19304 ) <br/>