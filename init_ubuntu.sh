#!/usr/bin/env bash

# curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/init_ubuntu.sh
# bash
# bash init_ubuntu.sh khchoi@fxgear.net ##### for company
# bash init_ubuntu.sh kyuhyoung@gmail.com ##### for private

echo $0 $@
if [ "$#" -ne 1 ] || ! [[ $1 == *"@"* ]]; then
  echo "Usage: $0 <e-mail address>" >&2
  echo "Example: $0 kyuhyoung@gmail.com" >&2
  exit 1
fi

# ---- 로그 + 에러 처리 셋업 -----------------------------------------------
# - 매 실행마다 init_ubuntu.log 새로 생성 (덮어쓰기)
# - 콘솔 + 로그 동시 출력, 라인 버퍼 flush (실시간)
# - 어느 스텝이든 에러 발생 시 line/command 표시 후 즉시 중단
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG="$SCRIPT_DIR/init_ubuntu.log"
: > "$LOG"
exec > >(stdbuf -oL tee "$LOG") 2>&1
set -Eeo pipefail
trap 'rc=$?; echo ""; echo "[ERROR] line $LINENO (exit $rc): $BASH_COMMAND" >&2; exit $rc' ERR
echo "[$(date '+%F %T')] init_ubuntu.sh start  (log: $LOG)"

sudo rm -rf ~/work/ubuntu_init
sudo mkdir -p ~/work/ubuntu_init

# Disable interactive prompts for apt
export DEBIAN_FRONTEND=noninteractive
export NEEDRESTART_MODE=a
# Configure needrestart to auto-restart services without asking
sudo mkdir -p /etc/needrestart/conf.d
echo "\$nrconf{restart} = 'a';" | sudo tee /etc/needrestart/conf.d/autorestart.conf > /dev/null

echo ""
echo "========================================================"
echo "========  apt update & fix dependencies ================"
echo "========================================================"
sudo apt-get update
sudo apt-get -f install -y
sudo apt-get upgrade -y

echo ""
echo "========================================================"
echo "========  mosh ========================================="
echo "========================================================"
sudo apt-get install -y protobuf-compiler build-essential libncurses5-dev libncursesw5-dev libtinfo-dev pkg-config autoconf automake libssl-dev
cd ~/work/ubuntu_init
sudo wget https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz
sudo tar xf mosh-1.4.0.tar.gz
cd mosh-1.4.0
sudo bash ./autogen.sh
sudo bash ./configure
sudo make
sudo make install
sudo ln -sf /usr/local/bin/mosh-server /usr/bin/mosh-server
sudo ln -sf /usr/local/bin/mosh-client /usr/bin/mosh-client
# Open UDP ports for mosh
sudo ufw allow 60000:61000/udp 2>/dev/null || sudo iptables -A INPUT -p udp --dport 60000:61000 -j ACCEPT

: << 'END'
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
END

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
mkdir -p ~/.config/fish/functions
sudo mv export.fish ~/.config/fish/functions/
sudo chown -R $(whoami):$(whoami) ~/.config/fish

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
rm -f ~/.ssh/id_rsa ~/.ssh/id_rsa.pub
ssh-keygen -t rsa -C $1 -f ~/.ssh/id_rsa -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
cat ~/.ssh/id_rsa.pub

# GitHub CLI (gh)
echo ""
echo "========================================================"
echo "========  GitHub CLI (gh) =============================="
echo "========================================================"
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt-get update
sudo apt-get install -y gh

: << 'END_SAMBA'
echo ""
echo "========================================================"
echo "========  samba ============================="
echo "========================================================"
sudo apt-get install -y samba
WHOAMI="$(/usr/bin/whoami)"
echo -e "$2\n$2" | sudo smbpasswd -s -a ${WHOAMI}
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf_temp
echo -e "[${WHOAMI}]\n comment = directory of ${WHOAMI}\n path = /home/${WHOAMI}\n valid users = ${WHOAMI}\n writeable = yes\n read only = no\n create mode = 0777\n directory mode = 0777" | sudo tee -a /etc/samba/smb.conf
sudo service smbd restart
sudo chown -R ${WHOAMI}:${WHOAMI} /home/${WHOAMI}
END_SAMBA

# tmux 3.4
echo ""
echo "========================================================"
echo "========  tmux ========================================="
echo "========================================================"
cd ~/work/ubuntu_init
sudo apt install -y libevent-dev ncurses-dev build-essential pipx
sudo wget https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
sudo tar -xzf tmux-3.4.tar.gz
cd tmux-3.4
sudo apt update && sudo apt install -y bison
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
sudo chown -R $USER: ~/.vim ~/.vimrc
sudo vi +'source ~/.vimrc' +qa
sudo vi +'PlugInstall' +qa

# Claude Code
echo ""
echo "========================================================"
echo "========  Claude Code =================================="
echo "========================================================"
# Install Node.js (LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
# Install Claude Code
sudo npm install -g @anthropic-ai/claude-code
