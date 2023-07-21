# modules/nixos/common.nix
# Configuration universal to all nix systems I am using,
# Anything in here will be easier to overlay than it will
# be to continuously state.
{ pkgs, config, inputs, ... }:
{
   imports =
  [
    ./home-manager/home-manager.nix # Home-Manager config, should be universal for all hosts
  ];

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  services.nix-daemon.enable = true;
#  services.openssh.enable = true;

#   users.users.caleb = {
#     isNormalUser = true;
#     home = "/home/caleb";
#     description = "Caleb Schmucker";
# #   shell = pkgs.fish; #Temporarily disabled due to failures
#     extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
#     initialPassword = ""; # Should be given a real password ASAP
#   };

}
