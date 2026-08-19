return {
    -- Nix LSP
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                nixd = {
                    settings = {
                        nixd = {
                            nixpkgs = {
                                expr = "import <nixpkgs> {}",
                            },
                        },
                    },
                },

                basedpyright = {},
                ruff = {
                    cmd = { "uv", "run", "ruff", "server" },
                },
            },
        },
    },

    -- -- Format + fix on save
    -- {
    --     "stevearc/conform.nvim",
    --     opts = {
    --         formatters_by_ft = { python = { "ruff_fix", "ruff_format" } },
    --     },
    -- },

    -- -- mypy on save
    -- {
    --     "mfussenegger/nvim-lint",
    --     opts = {
    --         linters_by_ft = { python = { "mypy" } },
    --         linters = {
    --             mypy = { cmd = "uv", args = { "run", "mypy", "--show-column-numbers" } },
    --         },
    --     },
    --     config = function(_, opts)
    --         local lint = require("lint")
    --         lint.linters_by_ft = opts.linters_by_ft
    --         lint.linters.mypy.cmd = "uv"
    --         lint.linters.mypy.args = { "run", "mypy", "--show-column-numbers" }
    --         vim.api.nvim_create_autocmd("BufWritePost", {
    --             pattern = "*.py",
    --             callback = function() lint.try_lint() end,
    --         })
    --     end,
    -- },
}