{
  description = "neovim flake configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };

      nvim = pkgs.symlinkJoin {
        name = "my-nvim";
        paths = [
          (pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped
            (pkgs.neovimUtils.makeNeovimConfig { })
          // { wrapRc = false; }
          )
        ];
        meta.mainProgram = "nvim";
      };
    in
    {
      packages.${system}.default = nvim;
    };
}
