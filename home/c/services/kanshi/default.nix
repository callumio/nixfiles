{...}: {
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.0;
            position = "0,0";
          }
        ];
      }
      {
        profile.name = "work";
        profile.outputs = [
          {
            criteria = "HP Inc. HP E27 G5 CNC33810R4";
            mode = "1920x1080@60.00Hz";
            position = "0,0";
          }
          {
            criteria = "eDP-1";
            status = "enable";
            scale = 1.0;
            position = "1920,0";
          }
        ];
      }
    ];
  };
}
