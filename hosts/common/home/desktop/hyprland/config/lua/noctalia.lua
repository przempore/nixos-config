local ipc = "noctalia msg "

hl.window_rule({
    name = "noctalia-settings",
    match = { class = "^dev.noctalia.Noctalia$" },
    float = true,
    size = { 1080, 920 },
})

hl.layer_rule({
    name = "noctalia-shell",
    match = {
        namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
    },
    no_anim = true,
    ignore_alpha = 0.5,
    blur = true,
    blur_popups = true,
})

hl.on("hyprland.start", function()
    hl.exec_cmd("noctalia")
    hl.exec_cmd("sleep 3 && uwsm-app -- keepassxc")
    hl.exec_cmd("uwsm finalize")
end)

hl.bind("SUPER + V", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"))
hl.bind("SUPER + F11", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind("CTRL + SHIFT + X", hl.dsp.exec_cmd(ipc .. "session lock"))
hl.bind("SUPER + R", hl.dsp.exec_cmd(ipc .. "settings-open theme"))
hl.bind("CTRL + ALT + R", hl.dsp.exec_cmd(ipc .. "settings-open theme"))
hl.bind("SUPER + M", hl.dsp.exec_cmd("noctalia-command-runner"))
hl.bind("CTRL + ALT + P", hl.dsp.exec_cmd(ipc .. "screenshot-region --annotate"))
hl.bind("CTRL + ALT + V", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center audio"))
hl.bind("SUPER + Y", hl.dsp.exec_cmd(ipc .. "bar-toggle"))
hl.bind("SUPER + TAB", hl.dsp.exec_cmd(ipc .. "window-switcher hold"))

hl.bind("ALT + UP", hl.dsp.exec_cmd(ipc .. "volume-up 2"))
hl.bind("ALT + DOWN", hl.dsp.exec_cmd(ipc .. "volume-down 2"))
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up 10"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down 10"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(ipc .. "mic-mute"), { locked = true, repeating = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. "media toggle"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(ipc .. "media stop"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. "media previous"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. "media next"), { locked = true })

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up current 5%"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down current 5%"), { locked = true, repeating = true })
hl.bind("ALT + PRIOR", hl.dsp.exec_cmd(ipc .. "brightness-up current 5%"))
hl.bind("ALT + NEXT", hl.dsp.exec_cmd(ipc .. "brightness-down current 5%"))

hl.bind("SUPER + CTRL + K", hl.dsp.exec_cmd("hyprland-keyboard-layout-switch"))

hl.bind("SUPER + F", hl.dsp.window.fullscreen({ action = "toggle", mode = "fullscreen" }))
hl.bind("SUPER + P", hl.dsp.window.pseudo({ action = "toggle" }))
hl.bind("SUPER + O", hl.dsp.window.float({ action = "toggle" }))
hl.bind("SUPER + Q", hl.dsp.window.close())
hl.bind("SUPER + SPACE", hl.dsp.workspace.toggle_special(""))
hl.bind("SUPER + BACKSPACE", hl.dsp.focus({ monitor = "next" }))
hl.bind("SUPER + SHIFT + LEFT", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + SHIFT + RIGHT", hl.dsp.window.move({ workspace = "-1" }))
hl.bind("SUPER + SHIFT + UP", hl.dsp.window.move({ workspace = "+1" }))
hl.bind("SUPER + SHIFT + DOWN", hl.dsp.window.move({ workspace = "-1" }))

for _, direction in ipairs({ "h", "j", "k", "l" }) do
    local dispatch_direction = ({ h = "l", j = "d", k = "u", l = "r" })[direction]
    hl.bind("SUPER + " .. direction, hl.dsp.focus({ direction = dispatch_direction }))
    hl.bind("SUPER + SHIFT + " .. direction, hl.dsp.window.swap({ direction = dispatch_direction }))
    hl.bind("SUPER + CTRL + SHIFT + " .. direction, hl.dsp.window.move({ direction = dispatch_direction }))
end

hl.bind("SUPER + E", hl.dsp.layout("togglesplit"))
hl.bind("SUPER + A", hl.dsp.layout("swapsplit"))
hl.bind("SUPER + D", hl.dsp.layout("preselect down"))

hl.bind("SUPER + ALT + LEFT", hl.dsp.window.resize({ x = -20, y = 0, relative = true }))
hl.bind("SUPER + ALT + DOWN", hl.dsp.window.resize({ x = 0, y = 20, relative = true }))
hl.bind("SUPER + ALT + UP", hl.dsp.window.resize({ x = 0, y = -20, relative = true }))
hl.bind("SUPER + ALT + RIGHT", hl.dsp.window.resize({ x = 20, y = 0, relative = true }))
hl.bind("SUPER + CTRL + LEFT", hl.dsp.window.move({ x = -20, y = 0, relative = true }))
hl.bind("SUPER + CTRL + DOWN", hl.dsp.window.move({ x = 0, y = 20, relative = true }))
hl.bind("SUPER + CTRL + UP", hl.dsp.window.move({ x = 0, y = -20, relative = true }))
hl.bind("SUPER + CTRL + RIGHT", hl.dsp.window.move({ x = 20, y = 0, relative = true }))

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })

local workspace_keys = {
    "plus", "bracketleft", "braceleft", "parenleft", "ampersand",
    "equal", "parenright", "braceright", "bracketright", "asterisk",
}

for workspace, key in ipairs(workspace_keys) do
    hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace }))
end

local function adjust_inner_gaps(delta)
    local gaps = hl.get_config("general.gaps_in")
    local function adjusted(value)
        return math.max(0, value + delta)
    end

    hl.config({
        general = {
            gaps_in = {
                top = adjusted(gaps.top),
                right = adjusted(gaps.right),
                bottom = adjusted(gaps.bottom),
                left = adjusted(gaps.left),
            },
        },
    })
end

hl.bind("SUPER + G", function()
    adjust_inner_gaps(2)
end)
hl.bind("SUPER + SHIFT + G", function()
    adjust_inner_gaps(-2)
end)
