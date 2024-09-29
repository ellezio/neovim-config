{
  description = "neovim configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nvim-lsp-file-operations = {
      url = "github:antosha417/nvim-lsp-file-operations";
      flake = false;
    };

    blackjack-nvim = {
      url = "github:alanfortlink/blackjack.nvim";
      flake = false;
    };
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

              nvim-lsp-file-operations = prev.vimUtils.buildVimPlugin {
                name = "nvim-lsp-file-operations";
                src = inputs.nvim-lsp-file-operations;
              };

              blackjack-nvim = prev.vimUtils.buildVimPlugin {
                name = "blackjack-nvim";
                src = inputs.blackjack-nvim;
              };
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

        { plugin = nvim-cmp; }
        { plugin = luasnip; }
        { plugin = cmp_luasnip; }
        { plugin = cmp-nvim-lsp; }
        { plugin = cmp-path; }
        { plugin = friendly-snippets; }

        { plugin = conform-nvim; }

        { plugin = nvim-dap; }
        { plugin = nvim-dap-ui; }
        { plugin = nvim-nio; }

        { plugin = vim-fugitive; }
        { plugin = vim-rhubarb; }
        { plugin = gitsigns-nvim; }

        { plugin = harpoon2; }

        { plugin = fidget-nvim; }
        { plugin = neodev-nvim; }
        { plugin = neoconf-nvim; }
        { plugin = nvim-lspconfig; }

        { plugin = lualine-nvim; }

        { plugin = neo-tree-nvim; }
        { plugin = nvim-web-devicons; }
        { plugin = nui-nvim; }
        { plugin = nvim-lsp-file-operations; }

        { plugin = outline-nvim; }

        { plugin = nvim-treesitter; }
        { plugin = nvim-treesitter-textobjects; }

        { plugin = vim-tmux-navigator; }

        { plugin = which-key-nvim; }

        { plugin = comment-nvim; }

        { plugin = indent-blankline-nvim; }

        { plugin = blackjack-nvim; }
      ] ++ (with pkgs.vimPlugins.nvim-treesitter-parsers; [
        { plugin = go; }
        { plugin = lua; }
        { plugin = rust; }
        { plugin = tsx; }
        { plugin = javascript; }
        { plugin = typescript; }
        { plugin = vimdoc; }
        { plugin = vim; }
        { plugin = bash; }
        { plugin = php; }
        { plugin = templ; }
        { plugin = c; }
        { plugin = comment; }
        { plugin = nix; }
      ]);

      neovimConfig = (pkgs.neovimUtils.makeNeovimConfig { inherit plugins; });

      config-drv = pkgs.stdenv.mkDerivation
        {
          name = "${name}-config";
          src = ./.;
          phases = [ "unpackPhase" "installPhase" ];
          installPhase = ''
            mkdir -p $out/${name}
            cp -r $src/* $out/${name}
          '';
        };

      finalePackage = pkgs.wrapNeovimUnstable
        pkgs.neovim-unwrapped
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

      nvim = pkgs.symlinkJoin
        {
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
