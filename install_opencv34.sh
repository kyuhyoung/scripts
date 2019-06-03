#!/usr/bin/env bash
# Automated script to install OpenCV 3.4.
# Tested on Ubuntu 16.04
# The source files would be downloaded to ~/opencv
#cd ~/
#mkdir opencv
#cd ~/opencv

#sudo apt-get update
#sudo apt-get install -y build-essential cmake
#sudo apt-get install -y qt5-default libvtk6-dev
#sudo apt-get install -y zlib1g-dev libjpeg-dev libwebp-dev libpng-dev libtiff5-dev libjasper-dev libopenexr-dev libgdal-dev
#sudo apt-get install -y libdc1394-22-dev libavcodec-dev libavformat-dev libswscale-dev libtheora-dev libvorbis-dev libxvidcore-dev libx264-dev yasm libopencore-amrnb-dev libopencore-amrwb-dev libv4l-dev libxine2-dev
#sudo apt-get install -y python-dev python-tk python-numpy python3-dev python3-tk python3-numpy
#
#sudo apt-get install -y unzip wget
DOWNLOADED=1
if [ -z ${DOWNLOADED+x} ]; then
	echo "Starting download install files."
	wget https://github.com/opencv/opencv/archive/3.4.0.zip
	unzip 3.4.0.zip
	sudo rm -rf 3.4.0.zip
	wget https://github.com/opencv/opencv_contrib/archive/3.4.0.zip
	unzip 3.4.0.zip
	sudo rm -rf 3.4.0.zip
else
	echo "Install files are already downloaded."
fi

cd opencv-3.4.0
sudo rm -rf build
mkdir build
cd build
#cmake -DBUILD_EXAMPLES=OFF ..
#####	for TX1	#####
#cmake -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-3.4.0/modules -D WITH_CUDA=ON -D CUDA_ARCH_BIN="5.3" -D CUDA_ARCH_PTX="" -D WITH_CUBLAS=ON -D ENABLE_FAST_MATH=ON -D CUDA_FAST_MATH=ON -D ENABLE_NEON=ON -D WITH_LIBV4L=ON -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=OFF -D BUILD_EXAMPLES=OFF -D WITH_QT=OFF -D WITH_GTK_2_X=ON -D WITH_GTK=ON -D WITH_OPENGL=ON -D WITH_VTK=ON -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) ..
#####	for GTX 1060 (Hansung TFG notebook	#####
#cmake -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-3.4.0/modules -D WITH_CUDA=ON -D CUDA_ARCH_BIN="6.1" -D CUDA_ARCH_PTX="" -D WITH_CUBLAS=ON -D ENABLE_FAST_MATH=ON -D CUDA_FAST_MATH=ON -D ENABLE_NEON=ON -D WITH_LIBV4L=ON -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=OFF -D BUILD_EXAMPLES=OFF -D WITH_QT=OFF -D WITH_GTK_2_X=ON -D WITH_GTK=ON -D WITH_OPENGL=ON -D WITH_VTK=ON -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) ..
#####	for DEVBOX   #####
cmake -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-3.4.0/modules -D CUDA_NVCC_FLAGS=--expt-relaxed-constexpr -D WITH_CUDA=ON -D WITH_CUBLAS=ON -D ENABLE_FAST_MATH=ON -D CUDA_FAST_MATH=ON -D ENABLE_NEON=ON -D WITH_LIBV4L=ON -D BUILD_DOCS=OFF -D BUILD_TESTS=OFF -D BUILD_PERF_TESTS=OFF -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D INSTALL_C_EXAMPLES=OFF -D INSTALL_PYTHON_EXAMPLES=OFF -D BUILD_EXAMPLES=OFF -D WITH_QT=OFF -D WITH_GTK_2_X=ON -D WITH_GTK=ON -D WITH_OPENGL=ON -D WITH_VTK=ON -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) ..
#Try
make -j12
#IF error occurs then try the below without j option
#make VERBOSE=1
sudo make install
sudo ldconfig
