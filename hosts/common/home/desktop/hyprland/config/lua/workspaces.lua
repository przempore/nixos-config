local workspace_labels = require("lua.workspace_labels")

return function(options)
    options = options or {}

    for workspace, label in ipairs(workspace_labels) do
        hl.workspace_rule({
            workspace = tostring(workspace),
            default_name = label,
            persistent = true,
            monitor = options.monitor,
        })
    end
end
