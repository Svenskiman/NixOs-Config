return {
    -- Yuck syntax highlighting
    {
        "elkowar/yuck.vim",
        ft = "yuck",
    },

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
                            options = {
                                nixos = {
                                    expr =
                                    '(builtins.getFlake "/home/svenski/.config/nixconf").nixosConfigurations.behemoth.options',
                                },
                                home_manager = {
                                    expr =
                                    '(builtins.getFlake "/home/svenski/.config/nixconf").homeConfigurations.svenski.options',
                                },
                            },
                        },
                    },
                },
            },
        },
    },
}
