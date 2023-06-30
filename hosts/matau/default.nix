# hosts/matau/default.nix
{ pkgs, config, inputs, ... }:

{
  imports =
  [
    ../../modules/common.nix # Install config universal to all of Nix
    ../../modules/darwin/common-darwin.nix # Install config required by Brew
  ];
  
  programs.zsh.enable = true;


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
    programs.fish.enable = true;
    home.packages = [
      pkgs.ripgrep
    ];
  };

}
