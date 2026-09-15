# overlays/

Version pins for packages where nixpkgs lags behind upstream.

Every `*.nix` file here is imported as a plain overlay (`final: prev: { ... }`)
by `default.nix`, which is imported from `configuration.nix`. Files starting
with `_` are shared helpers, not overlays.

## Adding a pin

```console
$ ./scripts/pin-package aome510/spotify-player 0.25.1
```

The script accepts `owner/repo` or a full GitHub URL, figures out the tag,
detects Rust packages (which need their cargo vendor dir rebuilt), writes the
overlay, and resolves every hash by building until Nix reports the mismatch.
Useful flags: `--attr NAME` when the nixpkgs attribute differs from the repo
name, `--tag TAG` for unusual tag formats, `--force` to replace an existing pin.

## Removing a pin

`_pin.nix` wraps each pinned package with an eval-time check. Once nixpkgs
catches up, every `nixos-rebuild` prints:

```
trace: warning: overlays/spotify-player.nix is stale: nixpkgs now ships
spotify-player 0.25.1, pin is 0.25.1. Delete nixos/overlays/spotify-player.nix
and rebuild.
```

Delete the file and rebuild. Nothing else references it.

## When the script isn't enough

A pin only overrides `version`, `src` and (for Rust) `cargoDeps`. If the new
release adds a dependency, changes its build system, or needs a patch dropped,
the build will fail and the generated file has to be edited by hand — it is an
ordinary overlay, so anything `overrideAttrs` can do is available.
