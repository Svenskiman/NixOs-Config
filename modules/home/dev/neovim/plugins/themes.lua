return {
    { "ellisonleao/gruvbox.nvim", opts = { contrast = "medium" } },
    { "shaunsingh/nord.nvim" },
    { "neanias/everforest-nvim", config = function() require("everforest").setup({ background = "hard" }) end },
    { "nyoom-engineering/oxocarbon.nvim" },

    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = function()
                local cs = "gruvbox"
                if jit.os ~= "OSX" then
                    local theme_file = io.open(os.getenv("HOME") .. "/.local/state/theme/active-theme")
                    if theme_file then
                        local theme_name = theme_file:read("*l")
                        theme_file:close()
                        local colorschemes = {
                            gruvbox = "gruvbox",
                            nord = "nord",
                            everforest = "everforest",
                            nocturne = "oxocarbon",
                            oxocarbon = "oxocarbon",
                        }
                        cs = colorschemes[theme_name] or "gruvbox"
                    end
                end
                vim.cmd("colorscheme " .. cs)
            end,
        },
    },
}