{
    pkgs ? import <nixpkgs> { system = builtins.currentSystem; },
}:

let 
    base = pkgs.appimageTools.defaultFhsEnvArgs;
in
pkgs.buildFHSUserEnv (base // {
    name = "escape";
    targetPkgs = pkgs: (base.targetPkgs pkgs) ++ [
          pkgs.pkg-config
          pkgs.ncurses
    ];
    profile = "export FHS=1";
    runScript = "zsh";
    extraOutputsToInstall = ["dev"];
})
