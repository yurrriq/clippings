with import <nixpkgs> {
  overlays = [
    (self: super: {
      elba = super.callPackage ./elba.nix {};
    })
  ];
};

mkShell {
  buildInputs = [
    elba
    (with idrisPackages; with-packages [ effects ])
  ];
}
