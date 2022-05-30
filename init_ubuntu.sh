#!/bin/sh

# curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/init_ubuntu.sh
# bash
# sh init_ubuntu.sh khchoi@fxgear.net ##### for company
# sh init_ubuntu.sh kyuhyoung@gmail.com ##### for private

echo $0 $@
if [ "$#" -ne 1 ] || ! [[ $1 == *"@"* ]]; then
  echo "Usage: $0 e-mail address" >&2
  exit 1
fi

echo ""
echo "========  nvidia-docker 2 ================================================================"
sudo ubuntu-drivers autoinstall

##########################################################################
######## reboot ##########################################################
##########################################################################

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
sudo docker run --rm --gpus all ubuntu:18.04 nvidia-smi

echo ""
echo "========  apt-get packages ================================================================"
sudo apt-get install -y wget gedit curl vim vim-gui-common vim-runtime fish git tmux
sudo rm -rf ~/work/etc
sudo mkdir -p ~/work/etc

# vim
echo ""
echo "========  vim ================================================================"
cd ~/work/etc
sudo rm -rf /root/.vim*
sudo git clone https://github.com/kyuhyoung/vi_setting.git
cd vi_setting
sudo cp -r .vim* /root/
sudo vi +'source /root/.vimrc' +qa
sudo vi +'PlugInstall --sync' +qa


# fish
echo ""
echo "========  fish ================================================================"
cd ~/work/etc
sudo curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/export.fish
sudo mkdir -p ~/.config/fish/functions
sudo mv export.fish ~/.config/fish/functions/

# tmux 2.6
echo ""
echo "========  tmux ================================================================"
cd ~/work/etc

sudo git clone https://github.com/kyuhyoung/tmux.git
cd tmux
sudo cp -r .tmux* ~/
sudo chown $(whoami):$(whoami) -R ~/.tmux
cd ~/.tmux/plugins
sudo git clone https://github.com/tmux-plugins/tpm.git 
sudo git clone https://github.com/NHDaly/tmux-better-mouse-mode.git
sudo git clone https://github.com/tmux-plugins/tmux-continuum.git
sudo git clone https://github.com/tmux-plugins/tmux-resurrect.git
sudo git clone https://github.com/tmux-plugins/tmux-sensible.git
tmux source-file ~/.tmux.conf

#sudo apt-get -y remove tmux
#sudo apt-get -y install wget tar libevent-dev libncurses-dev
#cd ~/Downloads
#VERSION=2.6
#wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
#tar xf tmux-${VERSION}.tar.gz
#rm -f tmux-${VERSION}.tar.gz
#cd tmux-${VERSION}
#./configure
#make
#sudo make install
#curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/.tmux.2.1.later.conf
#sudo mv .tmux.2.1.later.conf ~/.tmux.conf
#tmux source-file ~/.tmux.conf

echo ""
echo "========  Google Chrome ================================================================"
cd ~/work/etc
sudo apt --fix-broken install
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

echo ""
echo "========  some utils ================================================================"
sudo apt-get install -y geeqie

# github, the last because of gedit.
echo ""
echo "========  github ================================================================"
#git config --global user.email "kyuhyoung@gmail.com"
git config --global user.email $1
git config --global user.name "Kyuhyoung Choi"
#ssh-keygen -t rsa -C "kyuhyhoung@gmail.com"
ssh-keygen -t rsa -C $1
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
gedit ~/.ssh/id_rsa.pub

