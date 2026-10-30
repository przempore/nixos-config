local setup_workspaces = require("lua.workspaces")

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.device({
    name = "at-translated-set-2-keyboard",
    -- Inherit the global layout so the bar can rebuild this keyboard's keymap.
    kb_options = "ctrl:swapcaps,altwin:swap_lalt_lwin",
})

setup_workspaces()
