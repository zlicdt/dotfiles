## kde
This repository stores my desktop configuration. The main branch will keep updated with the configuration on my computer.

### Restore Konsole, KDE appearance, and SDDM
This directory contains an Arch package for the portable part of the current Plasma 6 setup:

- Konsole `clipsneko` profile with the bundled Catppuccin Mocha color scheme
- Breeze Dark colors, Breeze widgets and icons, and the Breeze Light cursor
- The `ayaws` global theme, current wallpaper, desktop layout, and bottom panel
- Breeze window decoration, title-bar button order, and rounded-corner effect settings
- The Breeze-based `breeze-clipsneko` SDDM theme and the current SDDM settings

The package installs system files and a user-facing helper. It deliberately does not
write a guessed user's home directory from a root pacman transaction.

On a new Arch Linux system, install the AUR rounded-corners effect first (it is a
required package dependency but is not in the official repositories), then build and
install this package:

```bash
paru -S kwin-effect-rounded-corners-git
makepkg -si
clipsneko-kde-configure
```

After logging in to Plasma, `clipsneko-kde-configure` backs up changed files under
`~/.config-dotfiles-backup`, installs the Konsole and Plasma files using the target
user's XDG paths, and asks before replacing the current desktop and panel layout.
Use `clipsneko-kde-configure --yes` for an unattended new-system install, or
`clipsneko-kde-configure --install-only` when no Plasma session is running.

For a one-command source-tree workflow, the compatibility wrapper builds the package,
installs it, and then runs the helper:

```bash
./install.sh
```

`./install.sh -y` passes `--noconfirm` to makepkg/pacman and resets the Plasma
layout without prompting.

The package does not enable display-manager services automatically. Enable SDDM
after confirming the new system is ready:

```bash
sudo systemctl enable sddm.service
```

### What Is Not Portable
After the package and helper finish, the following current-host state is still
intentionally different or requires a separate choice:

- Display scaling and monitor output settings (`kwinoutputconfig.json`)
- Per-device mouse settings and hardware IDs (for example Logitech pointer acceleration)
- Virtual-desktop UUIDs and any saved tiling layout UUIDs
- Global shortcuts, KWin window rules, power-management policy, lock-screen policy,
  Dolphin/application settings, MIME/default applications, and shell configuration
- Fcitx5 user state, dictionaries, and input-method theme settings
- Generated GTK compatibility files and the live `plasmashellrc` runtime panel state

The package does include the current panel/layout template and the SDDM background.
Installed KDE applets and services (NetworkManager, audio, Bluetooth, KDE Connect,
Vault, printing, and power management) must still exist on the target system for
their panel entries to be useful. Package updates may also refresh the system Breeze
files referenced by `breeze-clipsneko`; rebuild this package if the upstream SDDM
theme changes its file layout.

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
