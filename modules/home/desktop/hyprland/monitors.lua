local v = require("vars")

hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

for _, m in ipairs(v.monitors) do
    hl.monitor({
        output = m.output,
        mode = m.mode,
        position = m.position,
        scale = m.scale,
        transform = m.transform,
        bitdepth = m.bitdepth,
    })
end