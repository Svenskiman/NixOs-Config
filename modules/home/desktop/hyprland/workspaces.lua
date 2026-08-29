local v = require("vars")

for _, w in ipairs(v.workspace_monitors) do
    hl.workspace_rule({ workspace = w.id, monitor = w.monitor })
end