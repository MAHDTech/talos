{
  pkgs,
  config,
  lib,
  ...
}: let
  packages = with pkgs; [
  ];

  devPackages = with pkgs; [
    gnumake
    direnv
    figlet
    git
    jq
    kubectl
    talosctl
  ];
in {
  name = "talos";

  env = {
    PROJECT = "talos";
  };

  cachix = {
    pull = [
      "pre-commit-hooks"
      "salt-labs"
    ];
    push = [
      "salt-labs"
    ];
  };

  devenv = {
    warnOnNewVersion = true;
  };

  dotenv = {
    enable = true;
    disableHint = false;
  };

  packages =
    packages
    ++ lib.optionals (!config.container.isBuilding) devPackages;

  enterShell = ''
    figlet -f starwars -w 120 $PROJECT

    echo Hello ''${USER:-user}, welcome to the $PROJECT project
  '';

  languages = {
    nix = {
      enable = true;
    };

    shell = {
      enable = true;
    };

    go = {
      enable = true;
    };
  };

  difftastic = {
    enable = true;
  };

  pre-commit = {
    default_stages = [
      "pre-commit"
    ];

    excludes = [];

    hooks = {
      actionlint = {
        enable = true;
      };

      alejandra = {
        enable = true;
        fail_fast = true;
        excludes = [
          "vendor/"
        ];
      };

      check-json = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      check-shebang-scripts-are-executable = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      check-symlinks = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      check-yaml = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      convco = {
        enable = true;
      };

      cspell = {
        enable = false;
        excludes = [
          "vendor/"
        ];
      };

      deadnix = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      dialyzer = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      editorconfig-checker = {
        enable = true;
      };

      hadolint = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      markdownlint = {
        enable = true;
        settings = {
          configuration = {
            MD013 = {
              line_length = 180;
            };
          };
        };
        excludes = [
          "vendor/"
        ];
      };

      nil = {
        enable = false;
        excludes = [
          "vendor/"
        ];
      };

      pre-commit-hook-ensure-sops = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      prettier = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      pretty-format-json = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      ripsecrets = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      shellcheck = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      shfmt = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      staticcheck = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      trim-trailing-whitespace = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      typos = {
        enable = true;
        excludes = [
          "vendor/"
        ];
      };

      yamllint = {
        enable = true;
        settings = {
          configuration = ''
            extends: relaxed
            rules:
              line-length: disable
              indentation: enable
          '';
        };
        excludes = [
          "vendor/"
        ];
      };
    };
  };

  starship = {
    enable = true;
    config = {
      enable = false;
    };
  };

  devcontainer = {
    enable = true;
    settings = {
      customizations = {
        vscode = {
          extensions = [
            "esbenp.prettier-vscode"
            "exiasr.hadolint"
            "github.vscode-github-actions"
            "golang.go"
            "gruntfuggly.todo-tree"
            "johnpapa.vscode-peacock"
            "kamadorueda.alejandra"
            "ms-azuretools.vscode-docker"
            "ms-kubernetes-tools.vscode-kubernetes-tools"
            "ms-vscode.makefile-tools"
            "nhoizey.gremlins"
            "pinage404.nix-extension-pack"
            "redhat.vscode-yaml"
            "streetsidesoftware.code-spell-checker"
            "tekumura.typos-vscode"
            "timonwong.shellcheck"
            "tuxtina.json2yaml"
            "vscodevim.vim"
            "wakatime.vscode-wakatime"
            "yzhang.markdown-all-in-one"
          ];
        };
      };
    };
  };

  enterTest = ''
    echo "Running devenv tests..."
  '';
}
