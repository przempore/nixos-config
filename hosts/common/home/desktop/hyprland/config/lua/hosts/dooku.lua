local setup_workspaces = require("lua.workspaces")

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

setup_workspaces()
