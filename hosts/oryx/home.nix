{ pkgs, ... }:

{
  imports = [
    ../../modules/home/config/zsh.nix
    ../../modules/home/apps/btop.nix
    ../../modules/home/apps/alacritty.nix
    ../../modules/home/dev/neovim/neovim.nix
  ];

  home = {
    username = "benmiller";
    homeDirectory = "/Users/benmiller";
    stateVersion = "24.11";
  };

  myModules = {
    zsh.enable = true;
    btop.enable = true;
    alacritty.enable = true;
    neovim.enable = true;
  };

  # CLI packages
  home.packages = with pkgs; [
    wget
    git
    fastfetch
    eza
    lazydocker
    pyenv
    postgresql
    nodejs_24
  ];

  # pyenv init (work requirement)
  programs.zsh.initExtra = ''
    export PYENV_ROOT="$HOME/.pyenv"
    [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
  '';
}
