{

  inputs = {
    # I think this should allow me to source the righht config for the right system type.
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    #  nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    # there could be minor differences between the commits of the Darwin stable channel and the Linux ones.
    # but they should be small. And the Darwin one will be behind. So here we're just defaulting to a
    # slightly older nixpkgs.
    home-manager.inputs.nixpkgs.follows = "nixpkgs-darwin";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-linux, nixpkgs-darwin
    , home-manager, darwin }:
    let
      genExtraNixpkgsChannels = config: {
        pkgsStableLinux = import nixpkgs-linux {
          inherit (pkgs) system;
          inherit (config.nixpkgs) config;
        };
        pkgsStableDarwin = import nixpkgs-darwin {
          inherit (pkgs) system;
          inherit (config.nixpkgs) config;
        };
        # note: Linux/NixOS and Darwin each have a stable channel,
        # but there's only one unstable channel
        pkgsUnstable = import nixpkgs-unstable {
          inherit (pkgs) system;
          inherit (config.nixpkgs) config;
        };
      };
      overlayNixpkgsChannelsModule = { config, ... }: {
        nixpkgs.overlays = [
          (final: prev: {
            inherit (genExtraNixpkgsChannels config)
              pkgsStableLinux pkgsStableDarwin pkgsUnstable;
          })
        ];
      };
    in {
      darwinConfigurations."gali" = darwin.lib.darwinSystem {
        # 2015 MBP, 13in
        system = "x86_64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/gali/default.nix
          overlayNixpkgsChannelsModule
        ];
      };
      darwinConfigurations."lewa" = darwin.lib.darwinSystem {
        # 2017 MBP, 15in
        system = "x86_64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/lewa/default.nix
          overlayNixpkgsChannelsModule
        ];
      };
      darwinConfigurations."matau" = darwin.lib.darwinSystem {
        # 2021 MBP, 14in
        system = "aarch64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/matau/default.nix
          overlayNixpkgsChannelsModule
        ];
        inputs = { inherit nixpkgs-unstable; };
      };
    };
}
