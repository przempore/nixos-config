local setup_workspaces = require("lua.workspaces")

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

hl.device({
    name = "at-translated-set-2-keyboard",
    kb_layout = "real-prog-dvorak,us",
    kb_options = "ctrl:swapcaps,altwin:swap_lalt_lwin",
})

setup_workspaces()
