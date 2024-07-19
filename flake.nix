{
  description = "neovim flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };


      neovimConfig = (pkgs.neovimUtils.makeNeovimConfig { });

      init = pkgs.writeText "init.lua" ''
        print('It works')
      '';

      extraWrapperArgs = [ "--add-flags" "-u ${init}" ];

      finalePackage = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (
        neovimConfig
        // {
          wrapRc = false;
          wrapperArgs = neovimConfig.wrapperArgs ++ extraWrapperArgs;
        }
      );

      nvim = pkgs.symlinkJoin {
        name = "my-nvim";
        paths = [
          finalePackage
        ];
        meta.mainProgram = "nvim";
      };

    in
    {
      packages.${system}.default = nvim;
    };
}
