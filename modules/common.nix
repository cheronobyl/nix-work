# modules/nixos/common.nix
# Configuration universal to all nix systems I am using,
# Anything in here will be easier to overlay than it will
# be to continuously state.
{ pkgs, config, inputs, ... }:
{
  
  services.nix-daemon.enable = true; 
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

}
