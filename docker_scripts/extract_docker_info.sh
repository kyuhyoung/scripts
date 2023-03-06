echo "==============================================================================================================================="
echo "Docker container info."
echo "==============================================================================================================================="
echo "USAGE : sudo docker run --rm -it --shm-size=64g -w \$PWD -v \$PWD:\$PWD \${docker_name} bash docker_file/extract_docker_info.sh"
echo "-------------------------------------------------------------------------------------------------------------------------------"
os=$(cat /etc/os-release | grep 'PRETTY_NAME' | cut -d '=' -f 2 | cut -d '"' -f 2) 
echo "OS : ${os}"
cpp=$(g++ --version | grep 'g++' | rev | cut -d' ' -f1 | rev)
echo "c++ : ${cpp}"
#: << 'END'
python=$(python --version | rev | cut -d' ' -f1 | rev)
echo "python : ${python}" 
cuda=$(ls -l /usr/local/ | grep 'cuda ->' | rev | cut -d'-' -f1 | rev)
echo "cuda : ${cuda}"
cudnn1=$(cat /usr/include/x86_64-linux-gnu/cudnn_v*.h | grep "#define CUDNN_MAJOR" | rev | cut -d' ' -f1 | rev)
cudnn2=$(cat /usr/include/x86_64-linux-gnu/cudnn_v*.h | grep "#define CUDNN_MINOR" | rev | cut -d' ' -f1 | rev)
cudnn3=$(cat /usr/include/x86_64-linux-gnu/cudnn_v*.h | grep "#define CUDNN_PATCHLEVEL" | rev | cut -d' ' -f1 | rev)
echo "cudnn : ${cudnn1}.${cudnn2}.${cudnn3}"
cv=$(dpkg -l | grep opencv | cut -d' ' -f3) 
echo "opencv : ${cv}"
tf=$(pip list | grep tensorflow | rev | cut -d' ' -f1 | rev)
echo "tensorflow : ${tf}"
torch=$(pip list | grep "torch " | rev | cut -d' ' -f1 | rev)
echo "pytorch : ${torch}"
tv=$(pip list | grep torchvision | rev | cut -d' ' -f1 | rev)
echo "torchvison : ${tv}"
trt=$(dpkg -l | grep TensorRT | cut -d' ' -f3) 
echo "tensorRT : ${trt}"
tb=$(pip list | grep "tensorboard " | rev | cut -d' ' -f1 | rev)
echo "tensorboard : ${tb}"
bazel=$(which bazel)
echo "bazel : ${bazel}"
echo "==============================================================================================================================="

#END
