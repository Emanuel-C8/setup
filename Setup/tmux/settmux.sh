install-tmux(){
echo "Installing Termux Package"
sudo apt install tmux
echo "Loading Configuration"
sudo touch ~/.tmux.conf
sudo cp tmux/.tmux.conf ~/.tmux.conf
echo "Completed Termux Configuration"
}
