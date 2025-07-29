#!/bin/bash

# Hyprland Configuration Installer 
# Target: Simple setup any Arch based distro

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'


print_status()   { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success()  { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning()  { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error()    { echo -e "${RED}[ERROR]${NC} $1"; }

# Prevent running as root
if [[ $EUID -eq 0 ]]; then
    print_error "Run this script as normal user (not root)."
    exit 1
fi

# Exit on any unhandled error
trap 'print_error "Script failed. Please review the log and fix errors."; exit 1' ERR

if ! command -v pacman >/dev/null 2>&1; then
  print_error "\e[31m[$0]: pacman not found, it seems that the system is not ArchLinux or Arch-based distros. Aborting...\e[0m\n"
  exit 1
fi

#update repos
print_status "Updating current repos"
sudo pacman -Syy && sudo pacman -Syu


# Ensure yay installed
if ! command -v yay &>/dev/null; then
    print_status "Installing yay AUR helper..."
    cd /tmp
    rm -rf yay-bin
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si --noconfirm
    cd ~
    rm -rf /tmp/yay-bin
else
    print_status "yay already installed."
fi


# Clone config repo (always fresh Dotfiles dir)
cd ~
[ -d ~/Dotfiles ] && rm -rf ~/Dotfiles
print_status "Cloning Hyprland-conf repo..."
git clone https://github.com/sllylles/Hyprland-conf.git Dotfiles

cd ~/Dotfiles


# Install required packages (official + AUR)
print_status "Installing all required packages..."

# Load official packages (minimal, edit as needed)
official_packages=(
    hyprland wayland-protocols wayland-utils grim slurp wl-clipboard wtype
    pipewire wireplumber pipewire-alsa pipewire-pulse pipewire-jack
    pamixer playerctl pavucontrol alsa-utils
    xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-desktop-portal
    sddm qt6-base qt6-wayland qt6-svg qt6-imageformats
    networkmanager nm-connection-editor
    bluez bluez-utils
    firefox dolphin btop fastfetch unzip zip
    ttf-dejavu noto-fonts ttf-font-awesome papirus-icon-theme adwaita-icon-theme
    git base-devel nerd-fonts code ttf-jetbrains-mono swww 
)

for pkg in "${official_packages[@]}"; do
    sudo pacman -S --needed --noconfirm $pkg
done

# Load AUR packages
aur_packages=(
    quickshell hypridle hyprlock grimblast matugen-bin mpvpaper ttf-material-symbols-variable-git
)

for pkg in "${aur_packages[@]}"; do
    yay -S --needed --noconfirm $pkg
done

print_success "All required packages installed."







