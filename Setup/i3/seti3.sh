#!/bin/bash
install-i3-and-remove-others(){
# 1. Ensure i3 is installed
echo "[*] Installing i3..."
sudo apt update
sudo apt install -y i3 xinit xterm

# 2. Remove common DEs and WMs
echo "[*] Removing common Desktop Environments and Window Managers..."

# Meta-packages (DEs)
sudo apt purge -y ubuntu-desktop kde-plasma-desktop gnome-shell cinnamon-desktop-environment \
  xfce4 lxqt lightdm gdm3 sddm mate-desktop-environment \
  budgie-desktop enlightenment pantheon

# Window Managers
sudo apt purge -y openbox fluxbox icewm awesome xmonad bspwm herbstluftwm

# 3. Purge login managers
echo "[*] Purging login managers..."
sudo apt purge -y lightdm gdm3 sddm lxdm nodm

echo "[*] Preserving all LibreOffice packages..."
dpkg -l | grep libreoffice | awk '{print $2}' | xargs sudo apt-mark manual

# 4. Remove leftover config packages (auto-identified)
echo "[*] Autoremove and clean..."
sudo apt autoremove --purge -y
sudo apt clean

# 5. Remove lingering DE-related packages using pattern search
echo "[*] Searching and removing DE-related packages except i3..."

# Remove packages with names that usually belong to DEs/WMs
PKGS=$(dpkg -l | grep -E 'gnome|kde|xfce|lxqt|mate|cinnamon|budgie|plasma|pantheon|lightdm|gdm|sddm' | awk '{print $2}' | grep -v i3)
if [[ -n "$PKGS" ]]; then
  echo "[*] Purging detected DE packages..."
  sudo apt purge -y $PKGS
fi

# 6. Delete leftover config directories
echo "[*] Removing old user config directories (backed up first)..."
cd ~
mkdir -p ~/.config_backup
mv ~/.config/{gnome,kde,xfce4,xfce,lxqt,openbox,fluxbox,plasma,xfwm4,awesome} ~/.config_backup 2>/dev/null

# 7. Reset .xinitrc to use i3
echo 'exec i3' > ~/.xinitrc

echo "[✓] Cleanup complete. Only i3 should remain."
}
