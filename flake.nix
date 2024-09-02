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

      plugins = with pkgs.vimPlugins; [
        { plugin = catppuccin-nvim; }
        { plugin = telescope-nvim; }
        { plugin = plenary-nvim; }
        { plugin = telescope-fzf-native-nvim; }
        { plugin = telescope-ui-select-nvim; }
      ];

      neovimConfig = (pkgs.neovimUtils.makeNeovimConfig { inherit plugins; });

      # TODO Separate lua files
      luaRcContent = ''
        -- ### Options ###
        ${builtins.readFile ./lua/options.lua}

        -- ### Telescope ###
        ${builtins.readFile ./lua/plugins/telescope.lua}

        -- ### Init ###
        ${builtins.readFile ./init.lua}
      '';

      finalePackage = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped
        (
          neovimConfig // { inherit luaRcContent; }
        );

      nvim = pkgs.symlinkJoin {
        name = "my-nvim";
        paths = [
          (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
            finalePackage
          ))
        ];
        meta. mainProgram = "nvim";
      };
    in
    {
      packages.${ system}. default = nvim;
    };
}
