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
      "firefox" # Move to Home Manager
      "hammerspoon"
      "rectangle"
      "visual-studio-code"
      "zoom"
    ];

     masApps = { # Installs apps from the Mac App Store using Brew.
     };
  };
}
