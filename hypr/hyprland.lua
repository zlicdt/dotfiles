-- Converted from hyprland.conf.

-- Variables
local proxySocks5 = "socks5://127.0.0.1:7890"
local proxyHttp = "http://127.0.0.1:7890"

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more
local mainMod = "SUPER"

local switchScript = "~/.config/hypr/switch_workspace.sh"

local function bind(keys, dispatcher, opts)
    return hl.bind(keys, dispatcher, opts)
end

local function exec(cmd)
    return hl.dsp.exec_cmd(cmd)
end

local function bindExec(keys, cmd, opts)
    return bind(keys, exec(cmd), opts)
end

-- See https://wiki.hyprland.org/Configuring/Monitors/
-- hl.monitor({ output = "DP-3", mode = "2560x1080@200", position = "0x0", scale = "1.0" })
-- For other users, please modify monitors to fit your configuration
hl.monitor({
    output = "",
    mode = "2560x1600@240",
    position = "auto",
    scale = "1.6",
})

hl.monitor({
    output = "",
    mode = "3840x2160@160",
    position = "auto",
    scale = "2",
})
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1.0" })

-- See https://wiki.hyprland.org/Configuring/Keywords/ for more

-- Execute your favorite apps at launch
-- hl.on("hyprland.start", function()
--     hl.exec_cmd("waybar & hyprpaper & firefox")
-- end)

-- Source a file (multi-file configs)
-- dofile(os.getenv("HOME") .. "/.config/hypr/myColors.lua")

-- For all categories, see https://wiki.hyprland.org/Configuring/Variables/
hl.config({
    xwayland = {
        force_zero_scaling = true,
    },

    input = {
        kb_layout = "us",
        kb_variant = "",
        kb_model = "",
        follow_mouse = 1,
        sensitivity = 0,
        accel_profile = "flat",

        touchpad = {
            natural_scroll = true,
        },

    },

    general = {
        -- See https://wiki.hyprland.org/Configuring/Variables/ for more
        gaps_in = 4,
        gaps_out = 8,
        border_size = 1,
        col = {
            -- active_border = "rgba(d3e4c9ff)",
            active_border = "rgba(ffffffff)",
            inactive_border = "rgba(2222227f)",
        },
        allow_tearing = true,
        layout = "dwindle",
        resize_on_border = true,
    },

    decoration = {
        -- See https://wiki.hyprland.org/Configuring/Variables/ for more
        rounding = 10,
        shadow = {
            enabled = true,
            color = "rgba(0000005f)",
            color_inactive = "rgba(0000003f)",
            range = 25,
        },
        blur = {
            enabled = true,
            size = 2,
            passes = 2,
            contrast = 1.2,
        },
    },

    cursor = {
        no_hardware_cursors = 1,
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        -- See https://wiki.hyprland.org/Configuring/Layouts/Dwindle-Layout/ for more
        preserve_split = true, -- you probably want this
        split_width_multiplier = 1.4,
    },

    misc = {
        -- force_hypr_chan = true
        mouse_move_enables_dpms = true,
        key_press_enables_dpms = true,
        render_unfocused_fps = 60,
    },
})

-- Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more
hl.curve("myBezier", {
    type = "bezier",
    points = {
        {0.05, 0.9},
        {0.1, 1.05},
    },
})

hl.animation({ leaf = "windowsMove", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "default", style = "popin 90%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "default", style = "popin 95%" })
hl.animation({ leaf = "border", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 3, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "default" })

-- Layer rules
hl.layer_rule({
    match = { namespace = "waybar" },
    blur = true,
    ignore_alpha = 0,
})
hl.layer_rule({
    match = { namespace = "notifications" },
    blur = true,
    ignore_alpha = 0,
})
hl.layer_rule({
    match = { namespace = "launcher" },
    blur = true,
    ignore_alpha = 0,
})

-- Window rules
-- pinned window style
hl.window_rule({
    match = { pin = true },
    border_color = "rgb(598da8)",
})
-- hl.window_rule({ match = { class = ".*" }, float = true })
-- hl.window_rule({ match = { class = "Alacritty" }, tile = true })
hl.window_rule({ match = { class = "kitty" }, tile = true })
hl.window_rule({ match = { class = "QQ" }, float = true })
hl.window_rule({ match = { title = "Volume Control" }, float = true })
hl.window_rule({ match = { title = "Qt 5 Configuration Tool" }, float = true })
hl.window_rule({ match = { title = "Qt 6 Configuration Tool" }, float = true })
hl.window_rule({ match = { title = "Fcitx Configuration" }, float = true })
hl.window_rule({ match = { class = "org.gnome.Nautilus" }, float = true })
hl.window_rule({
    match = { class = "firefox" },
    float = true,
    center = true,
    size = {"monitor_w*0.75", "monitor_h*0.75"},
})
hl.window_rule({ match = { class = "qemu.*" }, float = true })
hl.window_rule({
    match = { class = "org.telegram.desktop", title = "Media viewer" },
    float = true,
})

-- Function key bindings
bindExec("XF86AudioMute", "pactl -- set-sink-mute @DEFAULT_SINK@ toggle")
bindExec("XF86AudioLowerVolume", "pactl -- set-sink-volume @DEFAULT_SINK@ -5%")
bindExec("XF86AudioRaiseVolume", "pactl -- set-sink-volume @DEFAULT_SINK@ +5%")
bindExec("XF86AudioMicMute", "pactl -- set-source-mute @DEFAULT_SOURCE@ toggle")
bindExec("XF86MonBrightnessUp", 'brightnessctl set $(($(brightnessctl get) + 10))')
bindExec("XF86MonBrightnessDown", 'brightnessctl set $(($(brightnessctl get) - 10))')

-- Hyprland hotkeys
bind(mainMod .. " + C", hl.dsp.window.close())
bindExec(mainMod .. " + T", "kitty")
bind(mainMod .. " + M", hl.dsp.exit())
bindExec(mainMod .. " + E", "[float] nautilus --new-window")
bind(mainMod .. " + V", hl.dsp.window.float())
bindExec(mainMod .. " + R", "tofi-drun | xargs hyprctl dispatch exec -- ALL_PROXY=" .. proxySocks5)
bind(mainMod .. " + P", hl.dsp.window.pseudo())
bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))
bind(mainMod .. " + F", hl.dsp.window.fullscreen())
bind(mainMod .. " + U", hl.dsp.window.bring_to_top())
bind(mainMod .. " + O", hl.dsp.dpms({ action = "enable" }))
bind(mainMod .. " + Z", hl.dsp.window.pin())
bindExec(mainMod .. " + L", "hyprlock")

-- Hyprland reload services
bindExec(mainMod .. " + CTRL + ALT + R", "killall waybar; waybar")
bindExec(mainMod .. " + CTRL + ALT + R", "killall fcitx5; fcitx5")
bindExec(mainMod .. " + CTRL + ALT + R", "killall hyprpaper; hyprpaper")

-- Screenshot
bindExec(mainMod .. " + SHIFT + S", 'grim -g "$(slurp -d)" - | wl-copy')
bindExec(mainMod .. " + SHIFT + W", [[grim -g "$(hyprctl -j activewindow | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" - | wl-copy]])
bindExec("Print", "grim - | wl-copy")

-- Open applications
bindExec(mainMod .. " + SHIFT + P", "/opt/sparkle/sparkle --enable-features=UseOzonePlatform --ozone-platform=wayland")
bindExec(mainMod .. " + SHIFT + B", "firefox")
bindExec(mainMod .. " + SHIFT + Q", "linuxqq --enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime")
bindExec(mainMod .. " + SHIFT + T", "telegram-desktop")
bindExec(mainMod .. " + SHIFT + C", "code --ozone-platform=wayland --enable-wayland-ime")

-- Move focus with mainMod + arrow keys
bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
bindExec(mainMod .. " + 1", switchScript .. " switch " .. 1)
bindExec(mainMod .. " + 2", switchScript .. " switch " .. 2)
bindExec(mainMod .. " + 3", switchScript .. " switch " .. 3)
bindExec(mainMod .. " + 4", switchScript .. " switch " .. 4)
bindExec(mainMod .. " + 5", switchScript .. " switch " .. 5)
bindExec(mainMod .. " + 6", switchScript .. " switch " .. 6)
bindExec(mainMod .. " + 7", switchScript .. " switch " .. 7)
bindExec(mainMod .. " + 8", switchScript .. " switch " .. 8)
bindExec(mainMod .. " + 9", switchScript .. " switch " .. 9)
bindExec(mainMod .. " + 0", switchScript .. " switch " .. 10)

bindExec(mainMod .. " + SHIFT + 1", switchScript .. " move " .. 1)
bindExec(mainMod .. " + SHIFT + 2", switchScript .. " move " .. 2)
bindExec(mainMod .. " + SHIFT + 3", switchScript .. " move " .. 3)
bindExec(mainMod .. " + SHIFT + 4", switchScript .. " move " .. 4)
bindExec(mainMod .. " + SHIFT + 5", switchScript .. " move " .. 5)
bindExec(mainMod .. " + SHIFT + 6", switchScript .. " move " .. 6)
bindExec(mainMod .. " + SHIFT + 7", switchScript .. " move " .. 7)
bindExec(mainMod .. " + SHIFT + 8", switchScript .. " move " .. 8)
bindExec(mainMod .. " + SHIFT + 9", switchScript .. " move " .. 9)
bindExec(mainMod .. " + SHIFT + 0", switchScript .. " move " .. 10)

bind(mainMod .. " + X", hl.dsp.workspace.toggle_special(""))
bind(mainMod .. " + SHIFT + X", hl.dsp.window.move({ workspace = "special" }))

bind(mainMod .. " + SHIFT + comma", hl.dsp.workspace.move({ monitor = "l" }))
bind(mainMod .. " + SHIFT + period", hl.dsp.workspace.move({ monitor = "r" }))

-- Bind workspaces
hl.workspace_rule({ workspace = "r[1-10]", monitor = "0" })
hl.workspace_rule({ workspace = "r[11-20]", monitor = "1" })

-- Scroll through existing workspaces with mainMod + scroll
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Environment
-- Some default env vars.
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("GDK_SCALE", "2")

-- Input Methods
hl.env("XMODIFIERS", "@im=fcitx")
-- This line is removed since it causes GTK applications crash (if without Wayland support)
-- hl.env("GTK_IM_MODULE", "wayland")
-- hl.env("QT_IM_MODULE", "wayland")
hl.env("SDL_IM_MODULE", "fcitx")

-- SDL wayland
-- This is deprecated since many clients does not support wayland
-- hl.env("SDL_VIDEODRIVER", "wayland,x11")

-- WLR_DRM_NO_ATOMIC
hl.env("WLR_DRM_NO_ATOMIC", "1")

-- NVIDIA Fix, remove if you don't use NVIDIA graphics cards
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- Other Environment
hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")

-- Proxy, configure it properly for your application
hl.env("ALL_PROXY", proxySocks5)
hl.env("HTTP_PROXY", proxyHttp)
hl.env("HTTPS_PROXY", proxyHttp)
hl.env("all_proxy", proxySocks5)
hl.env("http_proxy", proxyHttp)
hl.env("https_proxy", proxyHttp)
hl.env("NO_PROXY", "127.0.0.0/8,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16")

-- Auto start
hl.on("hyprland.start", function()
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("waybar")
    hl.exec_cmd("fcitx5")
    hl.exec_cmd("dbus-update-activation-environment --systemd --all")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("/opt/sparkle/sparkle --enable-features=UseOzonePlatform --ozone-platform=wayland")
end)
