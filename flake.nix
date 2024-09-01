{
  description = "neovim flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: prev: {
            # Add custom plugins here
            vimPlugins = prev.vimPlugins // {
              # Example of adding plugins:
              #
              # todo: figure out how 'buildNeovimPlugin' works
              # <pluginName> = prev.vimUtils.buildVimPlugin {
              #   name = "<pluginName>";
              #   src = <pluginSrc>;
              # };
            };
          })
        ];
      };

      plugins = [
        { plugin = pkgs.vimPlugins.catppuccin-nvim; }
      ];

      neovimConfig = (pkgs.neovimUtils.makeNeovimConfig { inherit plugins; });

      finalePackage = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
        neovimConfig
        // {
          wrapRC = false;
          wrapperArgs = neovimConfig.wrapperArgs ++ [ "--add-flags" ''-u ${./init.lua}'' ];
        }
      );

      nvim = pkgs.symlinkJoin {
        name = "my-nvim";
        paths = [
          (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
            finalePackage
          ))
        ];
        meta.mainProgram = "nvim";
      };
    in
    {
      packages.${system}.default = nvim;
    };
}
