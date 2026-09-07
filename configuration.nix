{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  nixpkgs.config.allowUnfree = true;

  hardware.enableRedistributableFirmware = true;
  
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # ========== Bootloader ==========
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 5;

  # Menu tambahan di systemd-boot (CachyOS)
  boot.loader.systemd-boot.extraEntries = {
    "cachyos.conf" = ''
      title CachyOS
      efi /EFI/cachyos/grubx64.efi
      sort-key 02_cachyos
    '';
  };

  # Otomatisasi tanda tangan Secure Boot setiap generasi baru NixOS di-build
  system.activationScripts.sbctlSign = {
    supportsDryActivation = false;
    text = ''
      if [ -x ${pkgs.sbctl}/bin/sbctl ]; then
        ${pkgs.sbctl}/bin/sbctl sign-all 2>/dev/null || true
        for kernel in /boot/EFI/nixos/*-bzImage.efi; do
          if [ -f "$kernel" ]; then
            ${pkgs.sbctl}/bin/sbctl sign -s "$kernel" 2>/dev/null || true
          fi
        done
        ${pkgs.sbctl}/bin/sbctl sign -s /boot/EFI/systemd/systemd-bootx64.efi 2>/dev/null || true
        ${pkgs.sbctl}/bin/sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI 2>/dev/null || true
        ${pkgs.sbctl}/bin/sbctl sign -s /boot/EFI/boot/bootx64.efi 2>/dev/null || true
      fi
    '';
  };
  
# Memaksa Intel Alder Lake menggunakan driver audio Legacy HDA (opsi 1)
boot.extraModprobeConfig = ''
  options snd-intel-dspcfg dsp_driver=1
'';

  # ========== Networking ========== 
  networking.hostName = "nixos-han"; # Sudah diaktifkan
  networking.networkmanager.enable = true;
  
  # ========== Time Zone ==========
  time.timeZone = "Asia/Jakarta";

  # ========== Virtualisation & Core System ========== 
  # virtualisation.vmware.guest.enable = true;
  programs.nix-ld.enable = true;

  # ========== Users ========== 
  users.users.han = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; 
    initialPassword = "raihan123";
    packages = with pkgs; [
      tree
    ];
  };

  # ========== Programs & GUI ==========
  programs.firefox.enable = true;
  
  programs.starship.enable = true;

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

# Aktifkan layanan pembuat thumbnail untuk Thunar
services.tumbler.enable = true;

  # # Mengaktifkan sistem X11
services.xserver.enable = true;
  
  # # Mengaktifkan LightDM sebagai layar login (Display Manager)
  services.xserver.displayManager.lightdm.enable = true;
  
  # # Mengaktifkan Qtile sebagai Window Manager
  # services.xserver.windowManager.qtile.enable = true;
  
# ================= Audio (PipeWire) =================
security.rtkit.enable = true; # Diperlukan agar audio tidak delay
services.pipewire = {
  enable = true;
  alsa.enable = true;
  alsa.support32Bit = true;
  pulse.enable = true;
};

services.blueman.enable = true;

# ================= Fonts =================
fonts.packages = with pkgs; [
  nerd-fonts.jetbrains-mono
  nerd-fonts.fira-code
  
  noto-fonts
  noto-fonts-color-emoji
  noto-fonts-cjk-sans
];

  # ========== System Packages ==========
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    fastfetch
    bat
    git
    gcc
    ripgrep
    fd
    unzip
    lazygit
    nodejs_22
    waybar
    obsidian
    alacritty
    pywal
    autotiling
    pavucontrol
    pamixer
    grim
    slurp
    thunar
    sof-firmware
    alsa-ucm-conf
    btop
    cava
    tty-clock
    wl-clipboard
    wdisplays
    efibootmgr
    sbctl
    sbsigntool
    eza
    bibata-cursors
    ffmpegthumbnailer # Preview untuk file video
    webp-pixbuf-loader # Preview untuk file gambar .webp
    poppler           # Preview untuk file .pdf
    pciutils
  ];

# Memastikan aplikasi Wayland & XWayland membaca tema kursor yang sama
environment.variables = {
  XCURSOR_THEME = "Bibata-Modern-Classic";
  XCURSOR_SIZE = "24";
};

# Dark mode
environment.variables = {
  GTK_THEME = "Adwaita:dark";
  QT_STYLE_OVERRIDE = "adwaita-dark";
};

  # ================= Aliases =================
environment.shellAliases = {
  snrs = "sudo nixos-rebuild switch";
  ls = "eza --icons";

};

environment.localBinInPath = true;

  # ========== Developer Tools (Opsional) ==========
  # environment.systemPackages = with pkgs; [
  #   git
  #   nodejs_20
  #   php
  #   php82Packages.composer
  #   python3
  # ];

  # ========== Services ========== 
  # services.openssh.enable = true;
  # services.xserver.xkb.layout = "us";

  # ========== System State ==========
  system.stateVersion = "26.05"; 

}
