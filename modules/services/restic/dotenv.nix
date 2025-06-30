{
  lib,
  file,
}: let
  # read the file and split on newlines
  lines = lib.splitString "\n" (builtins.readFile file);

  # keep only non-empty, non-comment lines
  clean = lib.filter (l: l != "" && !(lib.hasPrefix "#" l)) lines;

  # turn each "KEY=val" line into { name = KEY; value = val; }
  kvPairs = map (l: let
    parts = lib.splitString "=" l;
  in {
    name = builtins.elemAt parts 0;
    value = lib.concatStringsSep "=" (lib.drop 1 parts);
  }) clean;
in
  # fold into an attribute-set { KEY = "val"; … }
  lib.foldl' (acc: kv: acc // {${kv.name} = kv.value;}) {} kvPairs
