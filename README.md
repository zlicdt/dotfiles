![Preview](screenshot.png)

## Dotfiles
This repository stores my desktop configuration. The main branch will keep updated with the configuration on my computer.

By the way, I switched to KDE now. Maybe there have some outdated item.

Check `kde` folder for KDE settings config.

This fork is based on [Cascade's repository](https://github.com/Isoheptane/dotfiles)

### Before Using
Some of the configurations may not fit your environment and may require special attention.

`hypr/hyprland.conf` have special configurations for **NVIDIA grapics cards**. If you are using other graphics adapters, you may need to remove these configs. 

`hypr/hyprland.conf` configured **proxy environment variables**. Remove these proxy settings if you are not using proxy.

Removed `fontconfig` because of the Chinese font switch to the `misans` font. This is an AUR package.

### Font Requirements
| Font | Required by |
| :--- | :---------- |
| UbuntuMono Nerd Font | Waybar, Hyprlock |
| HarmonyOS Sans SC | Mako, fcitx5 |
| UbuntuMono Nerd Font Mono | Kitty |
| HarmonyOS Sans, adobe-source-han-sans-kr-fonts | Mostly used in UI |

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
| Graphics | NVIDIA GeForce RTX 5070 Ti |
| Monitor | 3840x2160 @ 160Hz |
