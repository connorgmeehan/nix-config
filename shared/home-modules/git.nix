{
  lib,
  pkgs,
  ...
}: {
  home.packages = lib.attrValues {
    inherit
      (pkgs)
      colordiff
      pre-commit
      ;
  };

  programs.gpg.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Connor Meehan";
    userEmail = "connorgm@pm.me";

    delta = {
      enable = true;
      # options.map-styles = "bold purple => syntax #8839ef, bold cyan => syntax #1e66f5";
    };

    includes = [
        {
            contents = {
                user = {
                    name = "Connor Guy Meehan";
                    email = "connorgm@pm.me";
                    signingKey = "1A602965FC593E9E";
                };
            };
        }
        {
            contents = {
                user = {
                    name = "Connor Guy Meehan";
                    email = "connor.meehan@drawboard.com";
                };
            };
            condition = "gitdir:~/projects/drawboard/";
        }
    ];

    extraConfig = {
      init = {defaultBranch = "main";};
      diff.colorMoved = "default";
      merge.conflictstyle = "diff3";
      delta = {
        syntax-theme = "Nord";
        line-numbers = true;
      };
      credential.helper = "${pkgs.gitAndTools.gitFull}/bin/git-credential-libsecret";
      merge = {
          ff = false;
      };
      pull = {
          ff = true;
      };
      rerere = {
          enabled = true;
      };
      # Sign all commits using ssh key
      commit.gpgsign = true;
    };

    aliases = {
      co = "checkout";
      fuck = "commit --amend -m";
      ca = "commit -am";
      d = "diff";
      pl = "!git pull origin $(git rev-parse --abbrev-ref HEAD)";
      af = "!git add $(git ls-files -m -o --exclude-standard | fzf -m)";
      st = "status";
      br = "branch";
      df = "!git hist | peco | awk '{print $2}' | xargs -I {} git diff {}^ {}";
      hist = ''
        log --pretty=format:"%Cgreen%h %Creset%cd %Cblue[%cn] %Creset%s%C(yellow)%d%C(reset)" --graph --date=relative --decorate --all'';
      llog = ''
        log --graph --name-status --pretty=format:"%C(red)%h %C(reset)(%cd) %C(green)%an %Creset%s %C(yellow)%d%Creset" --date=relative'';
      edit-unmerged = "!f() { git ls-files --unmerged | cut -f2 | sort -u ; }; nvim `f`";
    };

    ignores = [
      "*~"
      ".DS_Store"
      "*.swp"
      "*result*"
      ".direnv"
      "node_modules"
    ];
  };
}
