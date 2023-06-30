{ pkgs, config, inputs, ... }:
# Configuration universal to Darwin/MacOS systems
{
  imports =
  [
    ./homebrew/common-brew.nix # Install applications using Brew that cannot be installed elsewhere.
  ];

  nix.package = pkgs._alt.unstable.nix;

  # Probably required by a bug, otherwise cannot access Caches
  nix.settings = {
    ssl-cert-file = "/etc/ssl/certs/ca-certificates.crt";
  }

  # These configure some settings from the Mac Settings Menu.
  system.defaults = {
    dock.autohide = true;
    NSGlobalDomain.AppleICUForce22HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };

  # Resolves an issue in Home Manager on Darwin
  users.users.caleb.home = "/Users/caleb";

}