#!/usr/bin/env bash

set -euo pipefail

readonly REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
readonly CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
readonly BACKUP_ROOT="$HOME/.config-dotfiles-backup"
readonly BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"

ASSUME_YES=0
INSTALL_PACKAGES=1
INSTALL_ZSH=0
COPY_ZSHRC=0

BASE_PACKAGES=(
    base
    linux-zen
    linux-firmware
    linux-zen-headers
    base-devel
    git
    zsh
    zsh-completions
    bash-completion
    btrfs-progs
    grub
    efibootmgr
    networkmanager
    openssh
    vim
    fcitx5-chinese-addons
    fcitx5-gtk
    fcitx5-configtool
    fastfetch
    btop
    eza
    os-prober
)

HYPRLAND_PACKAGES=(
    hyprland
    hypridle
    hyprlock
    hyprpaper
    xdg-desktop-portal-hyprland
    mako
    waybar
    kitty
    uwsm
    pipewire
    wireplumber
    pipewire-pulse
    pipewire-alsa
    qt5-wayland
    qt6-wayland
    firefox
    nautilus
)

SCREENSHOT_PACKAGES=(
    grim
    slurp
    wl-clipboard
)

ZSH_PACKAGES=(
    zsh-syntax-highlighting
    zsh-autosuggestions
    pkgfile
)

CONFIG_DIRS=(
    hypr
    waybar
    mako
    kitty
    fcitx5
)

usage() {
    cat <<EOF
Usage: ./install.sh [options]

Install these dotfiles on an already-installed Arch Linux system.

Options:
  -y, --yes          Answer yes to installer prompts and pass --noconfirm to pacman
      --no-packages Skip pacman package installation
      --zsh         Install zsh extras, Oh My Zsh, and powerlevel10k
      --copy-zshrc  Copy bonus/.zshrc to ~/.zshrc, backing up an existing file
  -h, --help         Show this help
EOF
}

log() {
    printf '\n==> %s\n' "$*"
}

warn() {
    printf 'warning: %s\n' "$*" >&2
}

die() {
    printf 'error: %s\n' "$*" >&2
    exit 1
}

confirm() {
    local prompt="$1"
    local default="${2:-n}"
    local answer

    if [[ "$ASSUME_YES" -eq 1 ]]; then
        return 0
    fi

    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n] "
    else
        prompt="$prompt [y/N] "
    fi

    read -r -p "$prompt" answer
    answer="${answer:-$default}"

    case "$answer" in
        y|Y|yes|YES) return 0 ;;
        *) return 1 ;;
    esac
}

as_root() {
    if [[ "$EUID" -eq 0 ]]; then
        "$@"
    else
        sudo "$@"
    fi
}

require_user() {
    [[ "$EUID" -ne 0 ]] || die "run this script as your normal user, not root"
}

check_arch_linux() {
    [[ -r /etc/os-release ]] || return 0

    # shellcheck disable=SC1091
    . /etc/os-release

    if [[ "${ID:-}" != "arch" && "${ID_LIKE:-}" != *"arch"* ]]; then
        warn "this script is written for Arch Linux, detected '${PRETTY_NAME:-unknown}'"
        confirm "Continue anyway?" "n" || exit 1
    fi
}

pacman_install() {
    local packages=("$@")
    local pacman_flags=(-S --needed)

    [[ "${#packages[@]}" -gt 0 ]] || return 0

    if [[ "$ASSUME_YES" -eq 1 ]]; then
        pacman_flags+=(--noconfirm)
    fi

    as_root pacman "${pacman_flags[@]}" "${packages[@]}"
}

install_readme_packages() {
    command -v pacman >/dev/null 2>&1 || die "pacman was not found"

    log "Installing core prerequisites from README.md"
    pacman_install "${BASE_PACKAGES[@]}"

    log "Installing Hyprland ecosystem packages from README.md"
    pacman_install "${HYPRLAND_PACKAGES[@]}"

    log "Installing screenshot packages from README.md"
    pacman_install "${SCREENSHOT_PACKAGES[@]}"
}

install_zsh_packages() {
    if [[ "$INSTALL_PACKAGES" -eq 0 ]]; then
        warn "skipping zsh package installation because --no-packages was used"
        return 0
    fi

    log "Installing zsh packages from README.md"
    pacman_install "${ZSH_PACKAGES[@]}"

    if command -v pkgfile >/dev/null 2>&1; then
        log "Updating pkgfile database"
        as_root pkgfile -u
    else
        warn "pkgfile is not available yet; run 'sudo pkgfile -u' after installing it"
    fi
}

ensure_backup_dir() {
    mkdir -p "$BACKUP_DIR"
}

backup_path() {
    local target="$1"
    local name="$2"

    ensure_backup_dir
    mv -- "$target" "$BACKUP_DIR/$name"
}

copy_config_dir() {
    local name="$1"
    local src="$REPO_DIR/$name"
    local dest="$CONFIG_HOME/$name"

    [[ -d "$src" ]] || die "missing source directory: $src"

    mkdir -p "$CONFIG_HOME"

    if [[ -e "$dest" || -L "$dest" ]]; then
        log "Backing up existing $dest"
        backup_path "$dest" "$name"
    fi

    log "Installing $name to $dest"
    cp -a -- "$src" "$dest"
}

copy_dotfiles() {
    for name in "${CONFIG_DIRS[@]}"; do
        copy_config_dir "$name"
    done
}

copy_zshrc() {
    local src="$REPO_DIR/bonus/.zshrc"
    local dest="$HOME/.zshrc"

    [[ -f "$src" ]] || die "missing source file: $src"

    if [[ -e "$dest" || -L "$dest" ]]; then
        log "Backing up existing $dest"
        backup_path "$dest" ".zshrc"
    fi

    log "Installing bonus/.zshrc to $dest"
    cp -a -- "$src" "$dest"
}

install_oh_my_zsh() {
    local omz_dir="$HOME/.oh-my-zsh"
    local p10k_dir="${ZSH_CUSTOM:-$omz_dir/custom}/themes/powerlevel10k"

    command -v git >/dev/null 2>&1 || die "git was not found"

    if [[ -d "$omz_dir" ]]; then
        log "Oh My Zsh already exists at $omz_dir"
    else
        log "Installing Oh My Zsh"
        git clone https://github.com/ohmyzsh/ohmyzsh "$omz_dir"
    fi

    if [[ -d "$p10k_dir" ]]; then
        log "powerlevel10k already exists at $p10k_dir"
    else
        log "Installing powerlevel10k"
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
    fi
}

enable_user_audio_services() {
    if systemctl --user show-environment >/dev/null 2>&1; then
        log "Enabling PipeWire and WirePlumber user services"
        systemctl --user enable --now pipewire.service wireplumber.service pipewire-pulse.service
    else
        warn "could not reach the user systemd manager; enable audio after login with:"
        warn "systemctl --user enable --now pipewire.service wireplumber.service pipewire-pulse.service"
    fi
}

print_post_install_notes() {
    cat <<EOF

Post-install notes:
  - Review monitor settings at: $CONFIG_HOME/hypr/hyprland.conf
  - Remove NVIDIA environment variables if this machine does not use NVIDIA.
  - Remove proxy variables if this machine does not use your proxy setup.
  - Fonts listed in README.md still need to be installed:
      UbuntuMono Nerd Font
      UbuntuMono Nerd Font Mono
      HarmonyOS Sans SC
      HarmonyOS Sans
      adobe-source-han-sans-kr-fonts
  - sparkle-bin is an AUR package. Install it manually if you keep the Sparkle autostart lines.
EOF

    if [[ -d "$BACKUP_DIR" ]]; then
        printf '  - Existing files were backed up to: %s\n' "$BACKUP_DIR"
    fi

    printf '\n'
}

parse_args() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -y|--yes)
                ASSUME_YES=1
                ;;
            --no-packages)
                INSTALL_PACKAGES=0
                ;;
            --zsh)
                INSTALL_ZSH=1
                ;;
            --copy-zshrc)
                COPY_ZSHRC=1
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                usage
                die "unknown option: $1"
                ;;
        esac
        shift
    done
}

main() {
    parse_args "$@"
    require_user
    check_arch_linux

    log "Installing dotfiles from $REPO_DIR"

    if [[ "$INSTALL_PACKAGES" -eq 1 ]]; then
        confirm "Install packages listed in README.md with pacman?" "y" && install_readme_packages
    fi

    confirm "Copy Hyprland, Waybar, Mako, Kitty, and fcitx5 configs to $CONFIG_HOME?" "y" && copy_dotfiles

    if [[ "$INSTALL_PACKAGES" -eq 1 || "$INSTALL_ZSH" -eq 1 ]]; then
        confirm "Enable PipeWire and WirePlumber user services?" "y" && enable_user_audio_services
    fi

    if [[ "$INSTALL_ZSH" -eq 1 ]]; then
        install_zsh_packages
        install_oh_my_zsh
    elif [[ "$ASSUME_YES" -eq 0 ]] && confirm "Install optional zsh extras, Oh My Zsh, and powerlevel10k?" "n"; then
        install_zsh_packages
        install_oh_my_zsh
    fi

    if [[ "$COPY_ZSHRC" -eq 1 ]]; then
        copy_zshrc
    elif [[ "$ASSUME_YES" -eq 0 ]] && confirm "Copy bonus/.zshrc to ~/.zshrc?" "n"; then
        copy_zshrc
    fi

    print_post_install_notes
}

main "$@"
