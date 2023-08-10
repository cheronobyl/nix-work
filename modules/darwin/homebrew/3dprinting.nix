# /modules/darwin/homebrew/3dprinting.nix
{ pkgs, config, inputs, ... }:

{
  homebrew = {

    casks = [ # Installs brew apps, should only be used when required as it is preferred to use home-manager as much as possible
      "autodesk-fusion360"
      "lycheeslicer"
      "prusaslicer"
      "superslicer" # Probably moveable to Home Manager
    ];

  };
}