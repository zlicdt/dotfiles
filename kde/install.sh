#!/usr/bin/env bash

set -euo pipefail

readonly REPO_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    cat <<'EOF'
Usage: ./install.sh [options]

Build and install the Arch package, then apply the KDE configuration for the
current user.

Options:
  -y, --yes          Do not prompt before resetting the Plasma layout
      --install-only Install user files without changing the live desktop
  -h, --help         Show this help
EOF
}

main() {
    local makepkg_args=(-si --needed)
    local apply_args=()

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -y|--yes)
                makepkg_args+=(--noconfirm)
                apply_args+=(--yes)
                ;;
            --install-only)
                apply_args+=(--install-only)
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            *)
                usage >&2
                printf 'error: unknown option: %s\n' "$1" >&2
                exit 1
                ;;
        esac
        shift
    done

    [[ "$EUID" -ne 0 ]] || {
        printf 'error: run this script as your normal user, not root\n' >&2
        exit 1
    }
    command -v makepkg >/dev/null 2>&1 || {
        printf 'error: required command not found: makepkg\n' >&2
        exit 1
    }

    (cd -- "$REPO_DIR" && makepkg "${makepkg_args[@]}")

    if ! command -v clipsneko-kde-configure >/dev/null 2>&1; then
        printf 'error: clipsneko-kde-configure was not installed by the package\n' >&2
        exit 1
    fi

    clipsneko-kde-configure "${apply_args[@]}"
}

main "$@"
