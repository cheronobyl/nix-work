{

inputs = {
  # I think this should allow me to source the righht config for the right system type. 
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
#  nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
  home-manager.url = "github:nix-community/home-manager/release-23.05";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
  # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
  darwin.url = "github:lnl7/nix-darwin";
  darwin.inputs.nixpkgs.follows = "nixpkgs";
};

outputs = { self, nixpkgs, home-manager, darwin }: {
  darwinConfigurations."gali" = darwin.lib.darwinSystem {
    # 2015 MBP, 13in
    system = "x86_64-darwin";
    modules = [ home-manager.darwinModules.home-manager ./hosts/gali/default.nix ];
  };
  darwinConfigurations."lewa" = darwin.lib.darwinSystem {
    # 2017 MBP, 15in
    system = "x86_64-darwin";
    modules = [ 
      home-manager.darwinModules.home-manager
      ./hosts/lewa/default.nix
      ];
  };
  darwinConfigurations."matau" = darwin.lib.darwinSystem {
    # 2021 MBP, 14in
    system = "aarch64-darwin";
    modules = [ 
      home-manager.darwinModules.home-manager
      ./hosts/matau/default.nix
      ];
  };
};

}
