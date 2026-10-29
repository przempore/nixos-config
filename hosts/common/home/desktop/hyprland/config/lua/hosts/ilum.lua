local setup_workspaces = require("lua.workspaces")

hl.monitor({
    output = "DP-2",
    mode = "3840x1600@144",
    position = "0x0",
    scale = 1,
})
hl.monitor({ output = "HDMI-A-1", disabled = true })
hl.monitor({ output = "HDMI-A-2", disabled = true })

hl.bind("SUPER + CTRL + P", hl.dsp.exec_cmd([[sh -c 'exec "$HOME/.config/hypr/scripts/toggle_projector.sh"']]))

hl.device({
    name = "logitech-m570",
    sensitivity = 0.3,
    accel_profile = "adaptive",
})

setup_workspaces({ monitor = "DP-2" })
