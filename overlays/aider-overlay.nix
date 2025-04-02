# overlays/aider-overlay.nix
final: prev: let
  version = "0.80.0";

  treeSitterLanguages = prev.python3.pkgs.buildPythonPackage rec {
    pname = "tree-sitter-languages";
    version = "0.17.2";
    src = prev.fetchPypi {
      inherit pname version;
      # placeholder; replace with correct sha256:
      sha256 = "sha256-aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=";
    };
    propagatedBuildInputs = [
      prev.python3.pkgs.tree_sitter
    ];
  };
in {
  aider-chat = prev.aider-chat.overrideAttrs (old: {
    version = version;
    src = prev.fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      tag = "v${version}";
      # placeholder; replace with correct sha256:
      hash = "sha256-bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb=";
    };
    propagatedBuildInputs =
      (old.propagatedBuildInputs or [])
      ++ [treeSitterLanguages];
  });
}
