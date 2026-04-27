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
sudo chown "$USER:$USER" ~/work ~/work/ubuntu_init

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
wget https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz
tar xf mosh-1.4.0.tar.gz
cd mosh-1.4.0
bash ./autogen.sh
bash ./configure
make
sudo make install
sudo ln -sf /usr/local/bin/mosh-server /usr/bin/mosh-server
sudo ln -sf /usr/local/bin/mosh-client /usr/bin/mosh-client
# Open UDP ports for mosh
sudo ufw allow 60000:61000/udp 2>/dev/null || sudo iptables -A INPUT -p udp --dport 60000:61000 -j ACCEPT

echo ""
echo "========================================================"
echo "========  apt-get packages ============================="
echo "========================================================"
sudo apt-get install -y wget curl vim vim-runtime fish git rename

# fish
echo ""
echo "========================================================"
echo "========  fish ========================================="
echo "========================================================"
cd ~/work/ubuntu_init
curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/export.fish
mkdir -p ~/.config/fish/functions
mv export.fish ~/.config/fish/functions/

echo ""
echo "========================================================"
echo "========  Google Chrome ================================"
echo "========================================================"
cd ~/work/ubuntu_init
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb

# github, the last because of gedit.
echo ""
echo "========================================================"
echo "========  github ======================================="
echo "========================================================"
#git config --global user.email "kyuhyoung@gmail.com"
git config --global user.email $1
git config --global user.name "Kyuhyoung Choi"
if [ ! -f ~/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -C "$1" -f ~/.ssh/id_rsa -N ""
fi
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

# tmux 3.4
echo ""
echo "========================================================"
echo "========  tmux ========================================="
echo "========================================================"
cd ~/work/ubuntu_init
sudo apt-get install -y libevent-dev pipx bison
wget https://github.com/tmux/tmux/releases/download/3.4/tmux-3.4.tar.gz
tar -xzf tmux-3.4.tar.gz
cd tmux-3.4
./configure && make
sudo make install

cd ~/work/ubuntu_init
rm -rf tmux
git clone https://github.com/kyuhyoung/tmux.git
cd tmux
rm -rf ~/.tmux ~/.tmux.conf
cp -r .tmux* ~/
cd ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm.git
git clone https://github.com/NHDaly/tmux-better-mouse-mode.git
git clone https://github.com/tmux-plugins/tmux-continuum.git
git clone https://github.com/tmux-plugins/tmux-resurrect.git
git clone https://github.com/tmux-plugins/tmux-sensible.git
[ -n "$TMUX" ] && tmux source-file ~/.tmux.conf || true

# vim
echo ""
echo "========================================================"
echo "========  vim =========================================="
echo "========================================================"
cd ~/work/ubuntu_init
rm -rf vi_setting
git clone https://github.com/kyuhyoung/vi_setting.git
cd vi_setting
cp -r .vim* ~/
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vi +PlugInstall +qall

# Claude Code
echo ""
echo "========================================================"
echo "========  Claude Code =================================="
echo "========================================================"
curl -fsSL https://claude.ai/install.sh | bash
