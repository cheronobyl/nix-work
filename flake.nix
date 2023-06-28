{

  inputs = {
    # I think this should allow me to source the righht config for the right system type.
    nixpkgs-linux.url = "github:NixOS/nixpkgs/nixos-23.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager/release-23.05";
    # there could be minor differences between the commits of the Darwin stable channel and the Linux ones.
    # but they should be small. And the Darwin one will be behind. So here we're just defaulting to a
    # slightly older nixpkgs.
    home-manager.inputs.nixpkgs.follows = "nixpkgs-darwin";
    darwin.url = "github:LnL7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = { self, nixpkgs-unstable, nixpkgs-linux, nixpkgs-darwin
    , home-manager, darwin }:
    let
      genExtraNixpkgsChannels = { config, system }: {
        stable.linux = import nixpkgs-linux {
          inherit system;
          inherit (config.nixpkgs) config;
        };
        stable.darwin = import nixpkgs-darwin {
          inherit system;
          inherit (config.nixpkgs) config;
        };
        # note: Linux/NixOS and Darwin each have a stable channel,
        # but there's only one unstable channel
        unstable = import nixpkgs-unstable {
          inherit system;
          inherit (config.nixpkgs) config;
        };
      };
      overlayNixpkgsChannelsModule = { config, pkgs, ... }: {
        nixpkgs.overlays = [
          (final: prev: {
            _alt = genExtraNixpkgsChannels { inherit config; inherit (pkgs) system; };
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
        inputs = { nixpkgs = nixpkgs-unstable; };
      };
      darwinConfigurations."matau" = darwin.lib.darwinSystem {
        # 2021 MBP, 14in
        system = "aarch64-darwin";
        modules = [
          home-manager.darwinModules.home-manager
          ./hosts/matau/default.nix
          overlayNixpkgsChannelsModule
        ];
        inputs = { nixpkgs = nixpkgs-darwin; };
      };
    };
}
