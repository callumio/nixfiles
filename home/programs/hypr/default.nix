{
  config,
  inputs,
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    # TODO: move to nix config over text
    settings = {
      "monitor" = ",prefered,auto,1";

      general = {
        gaps_in = 0;
        gaps_out = 0;
        border_size = 1;
      };

      decoration = {
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };

      animations = {
        enabled = true;
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 1, default, popin"
          "fade, 1, 7, default"
          "workspaces, 1, 1, default, fade"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        no_gaps_when_only = 1;
      };

      master = {
        no_gaps_when_only = 1;
      };

      gestures.workspace_swipe = false;

      misc = {
        enable_swallow = true;
        swallow_regex = "Alacritty";
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      input = {
        kb_layout = "gb,us";
        kb_variant = ",workman";
        kb_model = "";
        kb_options = "ctrl:nocaps, grp:alt_shift_toggle";
        kb_rules = "";

        follow_mouse = true;

        touchpad = {
          natural_scroll = true;
          scroll_factor = 0.3;
        };

        sensitivity = 0.5;
        accel_profile = "flat";
        scroll_method = "2fg";
      };

      "$mainMod" = "SUPER";

      bind =
        [
          "$mainMod, q, killactive"
          "$mainMod SHIFT, q, exit"
          "$mainMod, F, fullscreen"
          "$mainMod SHIFT, f, togglefloating"
          "$mainMod, d, exec, rofi -show drun"
          "$mainMod, w, exec, rofi -show window"
          "$mainMod, p, exec, rofi-rbw --no-folder"
          "$mainMod, s, togglesplit"
          "$mainMod SHIFT, r, exec, hyprctl reload"
          "$mainMod, return, exec, alacritty -e tmux new -A -s main"
          "$mainMod SHIFT, return, exec, [float; pin] alacritty -e tmux new -A -s main"

          "$mainMod, b, workspace, name:web"
          "$mainMod, n, workspace, name:chat"
          "$mainMod, m, workspace, name:media"
          "$mainMod, v, workspace, name:mail"

          "$mainMod SHIFT, b, movetoworkspace, name:web"
          "$mainMod SHIFT, n, movetoworkspace, name:chat"
          "$mainMod SHIFT, m, movetoworkspace, name:media"
          "$mainMod SHIFT, v, movetoworkspace, name:mail"

          "$mainMod CTRL, b, moveworkspacetomonitor, name:web current"
          "$mainMod CTRL, n, moveworkspacetomonitor, name:chat current"
          "$mainMod CTRL, m, moveworkspacetomonitor, name:media current"
          "$mainMod CTRL, v, moveworkspacetomonitor, name:mail current"
          "$mainMod CTRL, b, workspace, name:web"
          "$mainMod CTRL, n, workspace, name:chat"
          "$mainMod CTRL, m, workspace, name:media"
          "$mainMod CTRL, v, workspace, name:mail"

          "$mainMod, h, movefocus, l"
          "$mainMod, l, movefocus, r"
          "$mainMod, k, movefocus, u"
          "$mainMod, j, movefocus, d"
          "$mainMod SHIFT, h, movewindow, l"
          "$mainMod SHIFT, l, movewindow, r"
          "$mainMod SHIFT, k, movewindow, u"
          "$mainMod SHIFT, j, movewindow, d"
          ''SHIFT, Print, exec, grim -g "$(slurp)" - | wl-copy''
          ", Print, exec, grim - | wl-copy"
        ]
        ++ (builtins.concatLists (builtins.genList (x: let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
            "$mainMod CTRL, ${ws}, moveworkspacetomonitor, ${
              toString (x + 1)
            } current"
            "$mainMod CTRL, ${ws}, workspace, ${toString (x + 1)}"
          ])
          10));

      workspace = [
        "name:web, on-created-empty: firefox"
        "name:chat, on-created-empty: discord"
        "name:media, on-created-empty: spotify"
        "name:mail, on-created-empty: betterbird"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      bindle = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute , exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute , exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioPlay , exec, playerctl play-pause"
        ", XF86AudioPause , exec, playerctl play-pause"
        ", XF86AudioNext , exec, playerctl next"
        ", XF86AudioPrev , exec, playerctl previous"
        ", XF86MonBrightnessUp, exec, brightnessctl -c backlight set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl -c backlight set 5%-"
      ];

      exec = [
        "pkill wpaperd & sleep 0.5 && wpaperd"
        "pkill waybar & sleep 0.5 && waybar"
        "pkill mako & sleep 0.5 && mako"
      ];

      exec-once = ["blueman-tray" "mullvad-gui" "udiskie -t"];
    };
  };
}
