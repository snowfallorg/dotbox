# DotBox ❤ Nix

<a href="https://nixos.wiki/wiki/Flakes" target="_blank">
	<img alt="Nix Flakes Ready" src="https://img.shields.io/static/v1?logo=nixos&logoColor=d8dee9&label=Nix%20Flakes&labelColor=5e81ac&message=Ready&color=d8dee9&style=for-the-badge">
</a>
<a href="https://github.com/snowfallorg/lib" target="_blank">
	<img alt="Built With Snowfall" src="https://img.shields.io/static/v1?logoColor=d8dee9&label=Built%20With&labelColor=5e81ac&message=Snowfall&color=d8dee9&style=for-the-badge">
</a>
<a href="https://dotbox.dev" target="_blank">
	<img alt="Powered By DotBox" src="https://img.shields.io/static/v1?logoColor=d8dee9&label=Powered%20By&labelColor=5e81ac&message=DotBox&color=d8dee9&style=for-the-badge">
</a>

<p>
<!--
	This paragraph is not empty, it contains an em space (UTF-8 8195) on the next line in order
	to create a gap in the page.
-->
  
</p>

This Nix Flake provides the [DotBox](https://dotbox.dev) command line package
as well as a development shell and Nix library which allows you to import DotBox
files into Nix.

## Try Without Installing

You can try DotBox out without committing to installing it on your system by running
the following command.

```bash
nix run github:snowfallorg/dotbox
```

## Install `dotbox`

### Nix Profile

You can install this package imperatively with the following command.

```bash
nix profile install github:snowfallorg/dotbox
```

### Nix Configuration

You can install this package by adding it as an input to your Nix flake.

```nix
{
	description = "My system flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";

		# Snowfall Lib is not required, but will make configuration easier for you.
		snowfall-lib = {
			url = "github:snowfallorg/lib";
			inputs.nixpkgs.follows = "nixpkgs";
		};

		dotbox = {
			url = "github:snowfallorg/dotbox";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs:
		inputs.snowfall-lib.mkFlake {
			inherit inputs;
			src = ./.;

			overlays = with inputs; [
				# Use the overlay provided by this flake.
				dotbox.overlay

				# There is also a named overlay, though the output is the same.
				dotbox.overlays."nixpkgs/snowfallorg"
			];
		};
}
```

If you've added the overlay from this flake, then in your system configuration
you can add the `snowfallorg.dotbox` package.

```nix
{ pkgs }:

{
	environment.systemPackages = with pkgs; [
		snowfallorg.dotbox
	];
}
```

## Dev Shell

If you want access to DotBox temporarily, you can enter a development shell
available with this flake.

```bash
nix develop github:snowfallorg/dotbox
```

## Library

This flake provides a helper library for integrating DotBox with Nix. See the
following example for information on using this flake's library.

```nix
{
	description = "My flake";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-22.05";

		dotbox = {
			url = "github:snowfallorg/dotbox";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, dotbox }:
		let
			# We require a NixPkgs instance in order to build DotBox files.
			pkgs = nixpkgs.legacyPackages.x86_64-linux;

			# Access helpers like `mkImporter` from `dotbox.lib`.
			importer = dotbox.lib.mkImporter pkgs;

			# Integrate your DotBox files with Nix!
			my-config = importer.import ./my.box;
			some-value = my-config.user.name.first;
		in
		{};
		
}
```

### `dotbox.lib.mkImporter`

Construct a DotBox importer.

Type: `Attrs -> Attrs`

Usage:

```nix
mkImporter pkgs
```

Result:

```nix
{ import = file: { /* ... */ }; }
```
