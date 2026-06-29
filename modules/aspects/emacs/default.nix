{ inputs, ... }:
{
  perSystem =
    { inputs', ... }:
    let
      # pkgs' = pkgs.unstable;
      pkgs' = inputs'.unstable.legacyPackages;
      tangledConfig = pkgs'.runCommand "init.el" { buildInputs = [ pkgs'.emacs-nox ]; } ''
        emacs --batch \
          --eval "(require 'ob-tangle)" \
          --eval "(org-babel-tangle-file \"${./init.org}\" \"$out\" \"emacs-lisp\")"
      '';
    in
    {
      packages.emacs-c = inputs.nix-wrapper-modules.wrappers.emacs.wrap {
        pkgs = pkgs';
        package = pkgs'.emacs-pgtk;

        emacsPackages =
          epkgs: with epkgs; [
            evil
            evil-collection
            evil-surround
            evil-commentary
            activities
            general
            which-key
            vertico
            orderless
            corfu
            magit
            consult
            marginalia
            nerd-icons-completion
            dirvish
            eglot
            consult-eglot
            eldoc-box
            cape

            indent-bars
            rainbow-delimiters

            rust-mode
            go-mode
            nix-mode
            markdown-mode

            doom-themes
            flyover

            diff-hl
            mood-line

            org-modern
            envrc

            eglot-booster

            ghostel # FIX: wait for https://github.com/melpa/melpa/pull/9949 AND https://github.com/dakra/ghostel/issues/76

            (treesit-grammars.with-grammars (
              g: with g; [
                tree-sitter-rust
                tree-sitter-yaml
                tree-sitter-dockerfile
              ]
            ))
          ];

        extraPackages = with pkgs'; [
          fd
          ripgrep
          nixfmt
          rust-analyzer
          clang-tools
          nil
          pyright
          gopls
          emacs-lsp-booster
        ];

        earlyConfigFile = builtins.readFile ./early-init.el;
        configFile = builtins.readFile tangledConfig;
        userDirectory = "~/.emacs.d";
      };
    };

  flake.homeManagerModules.emacs =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.emacs-c ];
      # TODO: service for emacs daemon
    };
}
