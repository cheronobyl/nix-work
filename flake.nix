{

inputs = {
  # I think this should allow me to source the righht config for the right system type. 
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-22.11-darwin";
  home-manager.url = "github:nix-community/home-manager";
  home-manager.inputs.nixpkgs.follows = "nixpkgs";
  # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
  darwin.url = "github:lnl7/nix-darwin";
  darwin.inputs.nixpkgs.follows = "nixpkgs";
};

outputs = { self, nixpkgs, nixpkgs-darwin, home-manager, darwin }: {
  darwinConfigurations."lewa" = darwin.lib.darwinSystem {
    # 2017 MBP, 15in
    system = "x86_64-darwin";
    modules = [ home-manager.darwinModules.home-manager ./hosts/lewa/default.nix ]; # will be important later
  };
  darwinConfigurations."gahli" = darwin.lib.darwinSystem {
    # 2015 MBP, 13in
    system = "x86_64-darwin";
    modules = [ home-manager.darwinModules.home-manager ./hosts/gali/default.nix ]; # will be important later
  };
};

}
