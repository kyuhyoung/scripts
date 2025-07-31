#!/bin/sh

# curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/init_ubuntu.sh
# bash
# bash init_ubuntu.sh khchoi@fxgear.net ##### for company
# bash init_ubuntu.sh kyuhyoung@gmail.com ##### for private

echo $0 $@
if [ "$#" -ne 1 ] || ! [[ $1 == *"@"* ]]; then
  echo "Usage: $0 e-mail address" >&2
  exit 1
fi

sudo rm -rf ~/work/ubuntu_init
sudo mkdir -p ~/work/ubuntu_init

echo ""
echo "========================================================"
echo "========  mosh ========================================="
echo "========================================================"
sudo apt-get install -y protobuf-compiler build-essential libncurses5-dev libncursesw5-dev libtinfo-dev pkg-config
cd ~/work/ubuntu_init
sudo wget https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz
sudo tar xf mosh-1.4.0.tar.gz
cd mosh-1.4.0
sudo bash ./autogen.sh
sudo bash ./configure
sudo make
sudo make install
sudo make check

echo ""
echo "========================================================"
echo "========  nvidia-docker 2 =============================="
echo "========================================================"
sudo ubuntu-drivers autoinstall

##########################################################################
######## reboot ##########################################################
##########################################################################

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add - && curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt update
sudo apt-get install -y nvidia-docker2
sudo systemctl restart docker
sudo docker run --rm --gpus all ubuntu:18.04 nvidia-smi
sudo apt autoremove -y

echo ""
echo "========================================================"
echo "========  apt-get packages ============================="
echo "========================================================"
sudo apt-get install -y wget gedit curl vim vim-gui-common vim-runtime fish git rename geeqie

# fish
echo ""
echo "========================================================"
echo "========  fish ========================================="
echo "========================================================"
cd ~/work/ubuntu_init
sudo curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/export.fish
sudo mkdir -p ~/.config/fish/functions
sudo mv export.fish ~/.config/fish/functions/

echo ""
echo "========================================================"
echo "========  Google Chrome ================================"
echo "========================================================"
cd ~/work/ubuntu_init
sudo apt --fix-broken install
sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# github, the last because of gedit.
echo ""
echo "========================================================"
echo "========  github ======================================="
echo "========================================================"
#git config --global user.email "kyuhyoung@gmail.com"
git config --global user.email $1
git config --global user.name "Kyuhyoung Choi"
#ssh-keygen -t rsa -C "kyuhyhoung@gmail.com"
ssh-keygen -t rsa -C $1
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

echo ""
echo "========================================================"
echo "========  samba ============================="
echo "========================================================"
sudo apt-get install -y samba
WHOAMI="$(/usr/bin/whoami)"
sudo smbpasswd -a ${WHOAMI}
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf_temp
echo -e "[${WHOAMI}]\n comment = directory of ${WHOAMI}\n path = /home/${WHOAMI}\n valid users = ${WHOAMI}\n writeable = yes\n read only = no\n create mode = 0777\n directory mode = 0777" | sudo tee -a /etc/samba/smb.conf
sudo service smbd restart
sudo chown -R ${WHOAMI}:${WHOAMI} /home/${WHOAMI}

# tmux 3.4
echo ""
echo "========================================================"
echo "========  tmux ========================================="
echo "========================================================"
cd ~/work/ubuntu_init
sudo apt install -y libevent-dev ncurses-dev build-essential
sudo wget https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
sudo tar -xzf tmux-3.4.tar.gz
cd tmux-3.4
sudo apt update && sudo apt install bison
sudo ./configure && sudo make
sudo make install

sudo rm -rf tmux
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

# vim
echo ""
echo "========================================================"
echo "========  vim =========================================="
echo "========================================================"
cd ~/work/ubuntu_init
sudo rm -rf /root/.vim*
sudo rm -rf vi_setting
sudo git clone https://github.com/kyuhyoung/vi_setting.git
cd vi_setting
sudo cp -r .vim* ~/
sudo curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo chown $USER: ~/.vim
sudo vi +'source ~/.vimrc' +qa
sudo vi +'PlugInstall' +qa
