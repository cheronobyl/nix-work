# inputshaper.nix
{ pkgs ? import <nixpkgs> {} }:
let
  my-python-packages = p: with p; [
  numpy
  matplotlib
  ];
  my-python = pkgs.python3.withPackages my-python-packages;
in my-python.env

