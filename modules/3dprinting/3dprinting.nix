{ config, pkgs, ... }:

{
  imports =
    [
      ./klipper.nix
    ];

  # nixpkgs.overlays  = [ 
  #   (final: prev: {klipper = prev.klipper.overrideAttrs(finalAttrs: prevAttrs {BuildInputs = matplotlib;});})
  # ];

  environment.systemPackages = with pkgs; [
    klipper
    moonraker
    octoprint
    polkit
   ];

  security.polkit.enable = true;

  users.users.fluidd = {
    isNormalUser = true;
    home = "/home/fluidd";
    description = "3d Printing User";
    extraGroups = [ ]; 
  };

  services.moonraker = {
    user = "root";
    enable = true;
    address = "0.0.0.0";
    settings = {
      octoprint_compat = { };
      history = { };
      authorization = {
        force_logins = true;
        cors_domains = [
          "*.local"
          "*.lan"
          "*://app.fluidd.xyz"
          "*://my.mainsail.xyz"
        ];
        trusted_clients = [
          "10.0.0.0/8"
          "127.0.0.0/8"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "192.168.1.0/24"
          "FE80::/10"
          "::1/128"
        ];
      };
    };
  };
  
  services.octoprint.enable = true;

  services.fluidd.enable = true;
  services.fluidd.nginx.locations."/webcam".proxyPass = "http://127.0.0.1:8080/stream";
  # Increase max upload size for uploading .gcode files from PrusaSlicer
  services.nginx.clientMaxBodySize = "1000m";

  systemd.services.ustreamer = {
    wantedBy = [ "multi-user.target" ];
    description = "uStreamer for video0";
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.ustreamer}/bin/ustreamer --encoder=HW --persistent --drop-same-frames=30'';
    };
  };

}