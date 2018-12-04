# curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/init_ubuntu.sh
# bash
# sh init_ubuntu.sh

# vim
echo ""
echo "========  vim ================================================================"
sudo apt-get install vim
cd ~/Downloads
sudo rm -rf vi_setting
git clone https://github.com/kyuhyoung/vi_setting.git
cd vi_setting
sudo mv .vimrc ~/
sudo rm -rf ~/.vim
sudo mv .vim ~/
cd ~/Downloads

# fish
echo ""
echo "========  fish ================================================================"
sudo apt-get install fish
cd ~/Downloads
curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/export.fish
sudo mkdir -p ~/.config/fish/functions
sudo mv export.fish ~/.config/fish/functions/

# tmux 2.6
echo ""
echo "========  tmux ================================================================"
sudo apt-get -y remove tmux
sudo apt-get -y install wget tar libevent-dev libncurses-dev
cd ~/Downloads
VERSION=2.6
curl -O https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
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
curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/.tmux.2.1.later.conf
sudo mv .tmux.2.1.later.conf ~/.tmux.conf
tmux source-file ~/.tmux.conf

# github, the last because of gedit.
echo ""
echo "========  github ================================================================"
git config --global user.email "kyuhyoung@gmail.com"
git config --global user.name "Kyuhyoung Choi"
ssh-keygen -t rsa -C "kyuhyhoung@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
gedit ~/.ssh/id_rsa.pub
