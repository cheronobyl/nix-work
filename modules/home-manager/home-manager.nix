{ pkgs, config, inputs, ... }:
# home-manager config
{
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.caleb = { pkgs, ... }: {
    home.stateVersion = "22.11";
    programs.tmux = { # my tmux configuration, for example
      enable = true;
      keyMode = "vi";
      clock24 = true;
      historyLimit = 10000;
      plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
        gruvbox
      ];
      extraConfig = ''
        new-session -s main
        bind-key -n C-a send-prefix
      '';
    };
    home.packages = [
      pkgs.ripgrep
      pkgs.git
      pkgs.vscode
      pkgs.firefox
    ];
    
  };
}