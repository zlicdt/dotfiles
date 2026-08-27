## kde
This repository stores my desktop configuration. The main branch will keep updated with the configuration on my computer.

### Restore Konsole and KDE appearance
This directory contains a portable snapshot of the current Plasma 6 appearance:

- Konsole `clipsneko` profile with the bundled Catppuccin Mocha color scheme
- Breeze Dark colors, Breeze widgets and icons, and the Breeze Light cursor
- The `ayaws` global theme, current wallpaper, desktop layout, and bottom panel
- Breeze window decoration, title-bar button order, and rounded-corner effect settings

On an Arch Linux Plasma 6 system, install the dependencies first:

```bash
sudo pacman -S ttf-ubuntu-mono-nerd
# Install kwin-effect-rounded-corners-git from the AUR as well.
```

Run the installer from this directory after logging in to Plasma:

```bash
./install.sh
```

The installer backs up changed files under `~/.config-dotfiles-backup`, installs
the theme using the target user's XDG paths, and asks before replacing the
current desktop and panel layout. Use `./install.sh -y` for an unattended new
system install, or `./install.sh --install-only` when no Plasma session is
running.

Display scaling, monitor output settings, mouse device settings, virtual desktop
IDs, and tiling layouts are intentionally not copied because they are tied to a
specific machine or Plasma session.

### Before Using
Some of the configurations may not fit your environment and may require special attention.

Removed `fontconfig` because of the Chinese font switch to the `misans` font. This is an AUR package.

The `.zshrc` is suite with Oh My Zsh. Please install it first before use this `.zshrc`. It alias ls -> eza, cat -> bat. And also fix for npm global package PATH.

### Installed applications
Package Collection
```
pacstrap /mnt base linux-zen linux-firmware linux-zen-headers base-devel git zsh zsh-completions bash-completion grub efibootmgr networkmanager openssh vim plasma kde-utilities kde-system fcitx5-chinese-addons fcitx5-gtk fcitx5-configtool fastfetch btop eza bat ntfs-3g os-prober
```

| Dev |
| :-- |
| rust |
| devtools |
| archiso |

| KDE app groups(as package) |
| :--- |
| plasma |
| kde-utilities |
| kde-system |

| App(as package) | Usage |
| :--- | :--- |
| sparkle-bin | VPN |
| linuxqq | Chat |
| microsoft-edge-stable-bin | Browser |
| netease-cloud-music-web-player | Netease Cloud Music |
| kwin-effect-rounded-corners-git | Apply round corner for electron apps |
| visual-studio-code-bin | The VSCode |
| hmcl-bin | Minecraft Launcher |
| npm | Node.js package manager(w/ set global package PATH) |

### Font Requirements
| Font(as package) | Required by |
| :--- | :---------- |
| ttf-ubuntu-mono-nerd | Konsole |
| ttf-harmonyos-sans(AUR) | Chinese font |
| adobe-source-han-sans-kr-fonts | Korean font |

### Port & Customization
Also, some of the configurations may not fit your environment. Here listed some important configurations of them.

### PC Build
PC 1:

| Component | Name |
| --------: | - |
| CPU | AMD Ryzen 9 7945HX |
| Graphics | NVIDIA GeForce RTX 4060 Laptop |
| Monitor | 2560x1600 @ 240Hz |

PC 2:

| Component | Name |
| --------: | - |
| CPU | AMD Ryzen 7 9700X, AMD Ryzen 9 9950X |
| Graphics | NVIDIA GeForce RTX 3080 |
| Monitor | 2560x1440 @ 165Hz, 3840x2160 @ 160Hz |
