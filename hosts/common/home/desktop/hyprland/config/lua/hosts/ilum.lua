hl.monitor({
    output = "DP-2",
    mode = "3840x1600@144",
    position = "0x0",
    scale = 1,
})
hl.monitor({ output = "HDMI-A-1", disabled = true })
hl.monitor({ output = "HDMI-A-2", disabled = true })

hl.device({
    name = "logitech-m570",
    sensitivity = 0.3,
    accel_profile = "adaptive",
})

for workspace = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(workspace),
        monitor = "DP-2",
        persistent = true,
    })
end
