{
  pkgs,
  cLib,
  ...
}: let
  getProgFor = cLib.getProgFor pkgs;
  getProgFor' = cLib.getProgFor' pkgs;
  tmux = getProgFor "tmux";
  tmux-sessionizer = getProgFor' "tmux-sessionizer-cl" "tmux-sessionizer";
in {
  programs.tmux = {
    enable = true;
    shortcut = "x";
    baseIndex = 0;
    escapeTime = 0;
    clock24 = true;
    mouse = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      {
        plugin = onedark-theme;
        extraConfig = "\n";
      }
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-strategy-vim 'session'
          set -g @resurrect-strategy-nvim 'session'
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-boot 'off'
          set -g @continuum-save-interval '10'
        '';
      }
    ];

    extraConfig = ''
      set-option -g status-position top
      set-option -g default-terminal "tmux-256color"
      set-option -sa terminal-features ',xterm-256color:RGB'
      set-window-option -g mode-keys vi

      bind / split-window -h -c "#{pane_current_path}"
      bind \\ split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      bind-key -r s run-shell "${tmux} display-popup -E '${tmux-sessionizer} -s'"
      bind-key -r f run-shell "${tmux} display-popup -E '${tmux-sessionizer} -p'"
      bind-key -r m run-shell "${tmux} switch-client -t main"
      bind S choose-tree

      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
    '';
  };

  # home.packages = [
  #   pkgs.tmux-sessionizer-cl
  # ];
}
