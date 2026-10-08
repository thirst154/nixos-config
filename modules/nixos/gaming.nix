{pkgs, ...}: {
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    # Dedicated-server and LAN-transfer ports intentionally left closed (laptop)
  };

  programs.gamemode.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    atlauncher
    ftb-app
    prismlauncher
    jdk8
    jdk17
    jdk21
  ];
}
