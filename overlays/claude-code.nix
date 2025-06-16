# overlays/claude-code.nix
final: prev: let
  version = "1.0.24"; # bump when npm publishes a new tag
in {
  claude-code = prev.buildNpmPackage rec {
    pname = "claude-code";
    inherit version;

    # Fetch the official npm tarball – cheaper than cloning the whole repo
    src = prev.fetchurl {
      url = "https://registry.npmjs.org/@anthropic-ai/claude-code/-/claude-code-${version}.tgz";
      # first run with lib.fakeSha256, build once, copy the hash from the
      # mismatch error and paste it here:
      hash = "sha256-REPLACE_ME";
    };

    # let buildNpmPackage vendor all transitive deps
    # fake hash → build once → copy the real hash
    npmDepsHash = "sha256-REPLACE_ME_TOO";

    # Claude’s CLI hard‑codes a shell path; with Nix binaries this check
    # sometimes fails.  A tiny wrapper fixes it.
    postInstall = ''
      wrapProgram $out/bin/claude \
        --set SHELL ${prev.bashInteractive}/bin/bash
    '';

    meta = with prev.lib; {
      description = "Anthropic Claude Code – AI coding agent for your terminal";
      homepage = "https://github.com/anthropics/claude-code";
      license = licenses.mit; # see repo
      maintainers = with maintainers; [yourGitHubNick];
      mainProgram = "claude";
    };
  };
}
