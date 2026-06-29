{
  pkgs,
  inputs,
  inputs',
}:
{
  tmux-sessionizer-cl = pkgs.callPackage ./tmux-sessionizer { };
  nvf = inputs'.nvf.packages.default;
  agenix = inputs'.agenix.packages.default;
  vaapiIntel = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  devour-flake = pkgs.callPackage inputs.devour-flake { };
  nish = inputs'.nish.packages.default;
  jellyfin-ffmpeg = pkgs.jellyfin-ffmpeg.override {
    ffmpeg_7-full = pkgs.ffmpeg_7-full.override {
      withMfx = false;
      withVpl = true;
    };
  };
}
