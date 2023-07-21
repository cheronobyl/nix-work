# hosts/matau/default.nix
{ pkgs, config, inputs, ... }:

{
  homebrew = {
    enable = true;
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
      cleanup = "zap"; # Wipes any brew actions done outside of a darwin-rebuild, does not wipe Mas-installed applications
    };

    casks = [ # Installs brew apps, should only be used when required as it is preferred to use home-manager as much as possible
      "iina"
      "discord"
      "keepassxc" # Move to Home Manager
      "firefox" # Move to Home Manager
      "hammerspoon"
      "iterm2"
      "jitsi-meet"
      "moonlight"
      "multiviewer-for-f1" # the best way to watch sports shit
      "protonvpn"
      "rectangle"
      "rustdesk"
      "steam"
      "visual-studio-code"
      "nrlquaker-winbox"
      "zoom"
    ];

     masApps = { # Installs apps from the Mac App Store using Brew.
     };
  };
}
