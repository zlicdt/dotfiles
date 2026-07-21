#!/usr/bin/env bash
set -euo pipefail

schema=org.gnome.desktop.interface
mode="${1:-toggle}"

if [[ "$mode" == toggle ]]; then
    case "$(gsettings get "$schema" color-scheme)" in
        *prefer-dark*) mode=light ;;
        *)             mode=dark ;;
    esac
fi

case "$mode" in
    dark)
        gsettings set "$schema" color-scheme prefer-dark
        gsettings set "$schema" gtk-theme Adwaita-dark
        ;;
    light)
        gsettings set "$schema" color-scheme prefer-light
        gsettings set "$schema" gtk-theme Adwaita
        ;;
    *)
        printf 'usage: %s [dark|light|toggle]\n' "$0" >&2
        exit 2
        ;;
esac
