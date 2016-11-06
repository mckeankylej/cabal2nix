{ nixpkgs ? import <nixpkgs> {}, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, ansi-wl-pprint, base, bytestring
      , Cabal, containers, deepseq, directory, distribution-nixpkgs
      , filepath, hackage-db, language-nix, lens, monad-par
      , monad-par-extras, mtl, optparse-applicative, pretty, process, SHA
      , split, stdenv, text, time, transformers, utf8-string, yaml
      }:
      mkDerivation {
        pname = "cabal2nix";
        version = "2.0.3";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          aeson ansi-wl-pprint base bytestring Cabal containers deepseq
          directory distribution-nixpkgs filepath hackage-db language-nix
          lens optparse-applicative pretty process SHA split text
          transformers yaml
        ];
        executableHaskellDepends = [
          aeson ansi-wl-pprint base bytestring Cabal containers deepseq
          directory distribution-nixpkgs filepath hackage-db language-nix
          lens monad-par monad-par-extras mtl optparse-applicative pretty
          process SHA split text time transformers utf8-string yaml
        ];
        homepage = "https://github.com/nixos/cabal2nix#readme";
        description = "Convert Cabal files into Nix build instructions";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
