# hosts/matau/default.nix
{ pkgs, config, inputs, ... }:

{
  # Make sure the nix daemon always runs
  services.nix-daemon.enable = true;
  nix.package = pkgs._alt.unstable.nix;
  nix.settings = {
    ssl-cert-file = "/etc/ssl/certs/ca-certificates.crt";
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  programs.zsh.enable = true;
  system.defaults = {
    dock.autohide = true;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };
  users.users.caleb.home = "/Users/caleb";
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
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    casks = [
      "iina"
      "discord"
      "keepassxc"
      "firefox"
      "hammerspoon"
      "iterm2"
      "multiviewer-for-f1"
      "moonlight"
      "protonvpn"
      "rectangle"
      "rustdesk"
      "superslicer"
      "steam"
      "visual-studio-code"
      "zoom"
      "nrlquaker-winbox"
    ];
  };

}
