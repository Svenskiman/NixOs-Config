return {
    {
        "Davidyz/inlayhint-filler.nvim",
        keys = {
            {
                "<Leader>I",
                function() require("inlayhint-filler").fill() end,
                desc = "Insert inlay hint",
            },
        },
    },
}
