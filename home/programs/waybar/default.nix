{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    package = pkgs.waybar.override {
      hyprlandSupport = true;
      swaySupport = false;
    };
    systemd.enable = false;
    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 20;
        modules-left = ["hyprland/workspaces" "hyprland/submap"];
        modules-center = ["hyprland/window"];
        modules-right = ["temperature" "wireplumber" "backlight" "battery" "clock" "tray"];
        clock = {
          tooltip = false;
          interval = 1;
          format = "{:%H:%M}";
          format-alt = "{:%d %B %Y, %A}";
        };
        battery = {
          states = {
            full = 99;
            good = 98;
            normal = 98;
            warning = 20;
            critical = 10;
          };
          format = "{icon}  {capacity}%";
          format-good = "{icon}  {capacity}%";
          format-full = "  {capacity}%";
          format-icons = ["" "" "" "" ""];
          tooltip = false;
        };
        wireplumber = {
          on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
          format = "{icon}  {volume}%";
          format-muted = "";
          format-icons = ["" "" ""];
          tooltip = false;
        };
        backlight = {
          format = "{icon} {percent}%";
          format-icons = ["" "" "" ""];
          tooltip = false;
        };
        tray = {
          icon-size = 18;
          spacing = 4;
          show-passive-items = true;
          tooltip = false;
        };
        temperature = {
          thermal-zone = 0;
          format = "{icon} {temperatureC}°C";
          format-icons = [""];
          interval = 30;
          tooltip = false;
        };
      };
    };

    style = ''
      * {
           min-height: 0;
           border: none;
           border-radius: 0;
           margin: 0px;
           font-size: 13px;
      }

      #workspaces button {
           margin: 0px;
           padding: 0 5px;
      }

      #workspaces button.focused, #workspaces button.active {
           border-bottom: 3px solid @base05;
      }

      #workspaces button:hover {
           background: alpha(@base05, 1);
           color: @base00;
      }
    '';
  };
}
