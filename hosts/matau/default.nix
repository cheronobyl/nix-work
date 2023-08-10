# hosts/matau/default.nix
{ pkgs, config, inputs, ... }:

{

  imports =
  [
    ../../modules/common.nix # Install config universal to all of Nix
    ../../modules/darwin/common-darwin.nix # Install config required by Brew
    ../../modules/darwin/homebrew/3dprinting.nix # Install some applications specific to 3d printing
  ];

}
