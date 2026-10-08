{pkgs, ...}: {
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.gdm.enableGnomeKeyring = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;

  # Printing: CUPS with driverless/IPP-USB, network discovery via mDNS
  services.printing.enable = true;
  services.ipp-usb.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Scanning: SANE backend (simple-scan app comes from GNOME core utilities)
  hardware.sane.enable = true;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
  };

  environment.systemPackages = with pkgs; [
    kitty
  ];
}
