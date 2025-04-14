{
  pkgs,
  inputs,
  inputs',
}: {
  tmux-sessionizer-cl = pkgs.callPackage ./tmux-sessionizer {};
  om = inputs'.omnix.packages.default;
  nvf = inputs'.nvf.packages.default;
  agenix = inputs'.agenix.packages.default;
  vaapiIntel = pkgs.vaapiIntel.override {enableHybridCodec = true;};
  devour-flake = pkgs.callPackage inputs.devour-flake {};
  nish = inputs'.nish.packages.default;
  nsbm = inputs'.nsbm.packages.default;
  jellyfin-ffmpeg = pkgs.jellyfin-ffmpeg.override {
    ffmpeg_7-full = pkgs.ffmpeg_7-full.override {
      withMfx = false;
      withVpl = true;
    };
  };
}
