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
  };

  # These configure some settings from the Mac Settings Menu.
  system.defaults = {
    dock.autohide = true;
    NSGlobalDomain.AppleICUForce24HourTime = true;
    NSGlobalDomain.AppleInterfaceStyle = "Dark";
  };

  # Resolves an issue in Home Manager on Darwin
  users.users.caleb.home = "/Users/caleb";
  users.users.caleb.shell = pkgs.fish ;
  programs.fish.enable = true; # preferred shell
  programs.zsh.enable = true; # default shell on catalina
  environment.loginShell = pkgs.fish ; # This doesnt seem to work properly, investigate later on
  environment.shells = with pkgs; [
    fish zsh
  ]; # nix-darwin appends macOS defaults for us

}