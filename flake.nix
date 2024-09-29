{
  description = "neovim flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      name = "my-nvim";
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

      config-drv = pkgs.stdenv.mkDerivation {
        name = "${name}-config";
        src = ./.;
        phases = [ "unpackPhase" "installPhase" ];
        installPhase = ''
          mkdir -p $out/${name}
          cp -r $src/* $out/${name}
        '';
      };

      finalePackage = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped
        (
          neovimConfig // {
            wrapRc = false;
            wrapperArgs = neovimConfig.wrapperArgs ++ [
              "--set"
              "XDG_CONFIG_HOME"
              "${config-drv}"

              "--set"
              "NVIM_APPNAME"
              name

              "--add-flags"
              "-u ${config-drv}/${name}/init.lua"
            ];
            packpathDirs.myNeovimPackages.start = neovimConfig.packpathDirs.myNeovimPackages.start ++ [ config-drv ];
          }
        );

      nvim = pkgs.symlinkJoin {
        inherit name;
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
