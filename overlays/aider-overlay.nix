# overlays/aider-overlay.nix
final: prev: let
  version = "0.82.0";
in {
  aider-chat = prev.aider-chat.overrideAttrs (old: {
    version = version;
    src = prev.fetchFromGitHub {
      owner = "Aider-AI";
      repo = "aider";
      tag = "v${version}";
      # placeholder; replace with correct sha256:
      hash = "sha256-W3GO5+0rprQHmn1upL3pcXuv2e9Wir6TW0tUnvZj48E=";
    };
    propagatedBuildInputs =
      old.propagatedBuildInputs or [];
  });
}
