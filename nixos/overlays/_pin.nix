# Helper for the version-pin overlays in this directory.
#
# Wraps a pinned package so that every `nixos-rebuild` prints a warning once
# nixpkgs' own version has caught up to (or passed) the pin. That warning is
# the signal that the overlay has done its job and the file can be deleted.
#
# Usage from an overlay:  pin prev "spotify-player" version (prev.spotify-player.overrideAttrs ...)
prev: name: version: drv:
prev.lib.warnIf (prev.lib.versionAtLeast prev.${name}.version version) ''
  overlays/${name}.nix is stale: nixpkgs now ships ${name} ${prev.${name}.version}, pin is ${version}.
  Delete nixos/overlays/${name}.nix and rebuild.
'' drv
