# NixOS module that registers every overlay in this directory.
#
# Each sibling `*.nix` file (except this one and anything starting with `_`,
# which is treated as a shared helper) is imported as a plain overlay
# `final: prev: { ... }`. Adding or removing a pin is therefore just adding or
# deleting a file -- nothing else needs to be edited.
{ lib, ... }:

let
  isOverlay = name: type: type == "regular" && lib.hasSuffix ".nix" name && !(lib.hasPrefix "_" name) && name != "default.nix";

  overlayFiles = lib.filterAttrs isOverlay (builtins.readDir ./.);
in
{
  nixpkgs.overlays = lib.mapAttrsToList (name: _: import (./. + "/${name}")) overlayFiles;
}
