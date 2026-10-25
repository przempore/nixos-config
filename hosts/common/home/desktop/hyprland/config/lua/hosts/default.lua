hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = 1,
})

for workspace = 1, 10 do
    hl.workspace_rule({
        workspace = tostring(workspace),
        persistent = true,
    })
end
