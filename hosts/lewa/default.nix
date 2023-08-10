# hosts/lewa/default.nix
{ pkgs, ... }:
{
  imports =
  [
    ../../modules/common.nix # Install config universal to all of Nix
    ../../modules/darwin/common-darwin.nix # Install config required by Brew
  ];

}
