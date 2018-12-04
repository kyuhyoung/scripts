# curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/init_ubuntu.sh
# bash
# sh init_ubuntu.sh

# vim
cd ~/Downloads
git clone https://github.com/kyuhyoung/vi_setting.git
cd vi_setting
mv .vimrc ~/
mv .vim ~/
cd ~/Downloads

# fish
sudo apt-get install fish

# tmux 2.6
sudo apt-get -y remove tmux
sudo apt-get -y install wget tar libevent-dev libncurses-dev
cd ~/Downloads
VERSION=2.6
wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
tar xf tmux-${VERSION}.tar.gz
rm -f tmux-${VERSION}.tar.gz
cd tmux-${VERSION}
./configure
make
sudo make install
#cd -
#sudo rm -rf /usr/local/src/tmux-*
#sudo mv tmux-${VERSION} /usr/local/src
#sudo killall -9 tmux
wget https://raw.githubusercontent.com/kyuhyoung/scripts/master/.tmux.2.1.later.conf
sudo mv .tmux.2.1.later.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf

# git, the last because of gedit.
ssh-keygen -t rsa -C "kyuhyhoung@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
gedit ~/.ssh/id_rsa.pub
