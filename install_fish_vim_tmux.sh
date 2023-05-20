echo ""
echo "========================================================"
echo "========  apt-get packages ============================="
echo "========================================================"
sudo apt-get install -y curl vim vim-gui-common vim-runtime fish git tmux
sudo rm -rf ~/work/ubuntu_init
sudo mkdir -p ~/work/ubuntu_init

# vim
echo ""
echo "========================================================"
echo "========  vim =========================================="
echo "========================================================"

cd ~/work/ubuntu_init
sudo rm -rf /root/.vim*
sudo git clone https://github.com/kyuhyoung/vi_setting.git
cd vi_setting
sudo cp -r .vim* ~/
sudo vi +'source ~/.vimrc' +qa
sudo vi +'PlugInstall' +qa


# fish
echo ""
echo "========================================================"
echo "========  fish ========================================="
echo "========================================================"
cd ~/work/ubuntu_init
sudo curl -O https://raw.githubusercontent.com/kyuhyoung/scripts/master/export.fish
sudo mkdir -p ~/.config/fish/functions
sudo mv export.fish ~/.config/fish/functions/

# tmux 2.6
echo ""
echo "========================================================"
echo "========  tmux ========================================="
echo "========================================================"
cd ~/work/ubuntu_init

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
