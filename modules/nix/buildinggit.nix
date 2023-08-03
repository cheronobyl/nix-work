{ pkgs, config, inputs, ... }:
# a shell env for working on Building Git

pkgs.mkshell {
  buildInputs = [
    pkgs.hexdump
    pkgs.ruby
    pkgs.tree
    pkgs.zlib
    pkgs.inflate
  ]
}