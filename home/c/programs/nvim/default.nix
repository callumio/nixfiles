{
  config,
  pkgs,
  lib,
  ...
}: {
  programs.neovim = let
    leaders = ''
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '
    '';
    toLua = str: ''
      lua << EOF
      ${leaders}
      ${str}
      EOF
    '';
    toLuaFile = file: ''
      lua << EOF
      ${leaders}
      ${builtins.readFile file}
      EOF
    '';
    toLuaFileLSP = file: ''
      lua << EOF
      ${leaders}
      ${builtins.readFile ./plugin/lsp/lsp-keys.lua}
      ${builtins.readFile file}
      EOF
    '';

    fromGit = ref: rev: repo:
      pkgs.vimUtils.buildVimPlugin {
        pname = "${lib.strings.sanitizeDerivationName repo}";
        version = ref;
        src = builtins.fetchGit {
          url = "https://github.com/${repo}.git";
          inherit ref;
          inherit rev;
        };
      };

    # always installs latest version
    pluginGit = fromGit "HEAD";
  in {
    enable = true;

    # package = pkgs.neovim-nightly;

    extraPackages = with pkgs; [
      # Rust
      rust-analyzer
      cargo
      rustc
      rustfmt

      # YAML
      yaml-language-server

      # JSON
      nodePackages.vscode-json-languageserver

      # Go
      gopls

      # Typescript
      nodePackages.typescript
      nodePackages.typescript-language-server

      # Javascript
      eslint_d

      # Python
      nodePackages.pyright
      black

      # Util
      ripgrep
      fzf

      # C-Family
      clang-tools

      # Shell
      shellcheck
      shfmt

      # Lua
      lua-language-server
      selene
      stylua

      # Nix
      rnix-lsp
      nixfmt
      statix

      # LLM
      ollama

      # Haskell
      haskellPackages.haskell-debug-adapter
      haskellPackages.haskell-language-server
      haskellPackages.fourmolu
      ghc

      # Docker
      dockerfile-language-server-nodejs
      docker-compose-language-service
    ];

    defaultEditor = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    extraLuaConfig = ''
      ${builtins.readFile ./options.lua}
    '';

    plugins = with pkgs.vimPlugins; [
      {
        plugin = nvim-lspconfig;
        config = toLuaFileLSP ./plugin/lsp/lsp.lua;
      }

      {
        plugin = crates-nvim;
        config = toLua "require('crates').setup()";
      }

      {
        plugin = rustaceanvim;
        config = toLuaFileLSP ./plugin/lsp/rust.lua;
      }

      {
        plugin = haskell-tools-nvim;
        config = toLuaFileLSP ./plugin/lsp/haskell.lua;
      }

      {
        plugin = SchemaStore-nvim;
        config = toLuaFileLSP ./plugin/lsp/schemastore.lua;
      }

      {
        plugin = todo-comments-nvim;
        config =
          toLua
          "require('todo-comments').setup(); vim.api.nvim_set_keymap('n', '<leader>vtd', ':TodoTelescope<CR>', { noremap = true });";
      }

      {
        plugin = comment-nvim;
        config = toLua "require('Comment').setup()";
      }

      {
        plugin = onedark-nvim;
        config = "colorscheme onedark";
      }

      neodev-nvim

      {
        plugin = nvim-cmp;
        config = toLuaFile ./plugin/cmp.lua;
      }

      {
        plugin = telescope-nvim;
        config = toLuaFile ./plugin/telescope.lua;
      }

      {
        plugin =
          pluginGit "951b163e55ce7639eb320c450bde9283c4fe968b"
          "laytan/cloak.nvim";
        config = toLuaFile ./plugin/cloak.lua;
      }

      {
        plugin =
          pluginGit "41ad952c8269fa7aa3a4b8a5abb44541cb628313"
          "David-Kunz/gen.nvim";
        config = toLuaFile ./plugin/gen.lua;
      }

      {
        plugin = nvim-dap;
        config = toLuaFile ./plugin/debugger.lua;
      }

      {
        plugin =
          pluginGit "fd35a46f4b7c1b244249266bdcb2da3814f01724"
          "xiyaowong/transparent.nvim";
        config = toLua "require('transparent').setup{}";
      }

      nvim-dap-ui
      telescope-dap-nvim
      nvim-dap-virtual-text

      telescope-fzf-native-nvim

      cmp_luasnip
      cmp-nvim-lsp

      luasnip
      friendly-snippets

      {
        plugin = hardtime-nvim;
        config = toLua "require('hardtime').setup()";
      }

      {
        plugin = nvim-surround;
        config = toLua "require('nvim-surround').setup{}";
      }

      {
        plugin = harpoon;
        config = toLuaFile ./plugin/harpoon.lua;
      }

      {
        plugin = lualine-nvim;
        config =
          toLua
          "require('lualine').setup{options = {icons_enabled = true, theme = 'onedark', component_separators = '|', section_separators = ''}, sections = { lualine_a = { { 'buffers', } } }}";
      }

      {
        plugin = nvim-autopairs;
        config = toLua "require('nvim-autopairs').setup {}";
      }

      {
        plugin = leap-nvim;
        config = toLua "require('leap.user').add_default_mappings()";
      }

      {
        plugin = none-ls-nvim;
        config = toLuaFile ./plugin/lsp/none-ls.lua;
      }

      {
        plugin = oil-nvim;
        config = toLuaFile ./plugin/oil.lua;
      }

      {
        plugin = zen-mode-nvim;
        config = toLuaFile ./plugin/zen.lua;
      }
      twilight-nvim

      nvim-web-devicons

      {
        plugin = undotree;
        config =
          toLua "vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)";
      }

      {
        plugin = gitsigns-nvim;
        config = toLuaFile ./plugin/gitsigns.lua;
      }

      {
        plugin = nvim-treesitter.withPlugins (p: [
          p.tree-sitter-nix
          p.tree-sitter-vim
          p.tree-sitter-bash
          p.tree-sitter-lua
          p.tree-sitter-python
          p.tree-sitter-rust
          p.tree-sitter-json
          p.tree-sitter-c
          p.tree-sitter-comment
          p.tree-sitter-javascript
          p.tree-sitter-fish
          p.tree-sitter-dockerfile
          p.tree-sitter-cpp
          p.tree-sitter-git_config
          p.tree-sitter-git_rebase
          p.tree-sitter-gitattributes
          p.tree-sitter-gitcommit
          p.tree-sitter-gitignore
          p.tree-sitter-markdown
          p.tree-sitter-markdown_inline
          p.tree-sitter-make
          p.tree-sitter-norg
          p.tree-sitter-ssh_config
          p.tree-sitter-typescript
          p.tree-sitter-tsx
          p.tree-sitter-haskell
          p.tree-sitter-yaml
          p.tree-sitter-zig
        ]);
        config = toLuaFile ./plugin/treesitter.lua;
      }

      vim-nix
    ];
  };
}
