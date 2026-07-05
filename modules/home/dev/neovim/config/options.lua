vim.o.background = "dark"
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.number = true
vim.o.relativenumber = false

vim.api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    end,
})
