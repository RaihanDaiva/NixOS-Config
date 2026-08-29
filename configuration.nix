{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # ========== Bootloader ==========
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ========== Networking ========== 
  networking.hostName = "nixos"; # Sudah diaktifkan
  networking.networkmanager.enable = true;
  
  # ========== Time Zone ==========
  time.timeZone = "Asia/Jakarta";

  # ========== Virtualisation & Core System ========== 
  virtualisation.vmware.guest.enable = true;
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

  # # Mengaktifkan sistem X11
  # services.xserver.enable = true;
  
  # # Mengaktifkan LightDM sebagai layar login (Display Manager)
  # services.xserver.displayManager.lightdm.enable = true;
  
  # # Mengaktifkan Qtile sebagai Window Manager
  # services.xserver.windowManager.qtile.enable = true;
  

  # ========== System Packages ==========
  environment.systemPackages = with pkgs; [
    vim
    wget
    neovim
    kitty
    fastfetch
    bat
    git
    gcc
    ripgrep
    fd
    unzip
    lazygit
    nodejs_22
  ];

  # ========== Developer Tools (Opsional) ==========
  # environment.systemPackages = with pkgs; [
  #   git
  #   nodejs_20
  #   php
  #   php82Packages.composer
  #   python3
  # ];

  # ========== Services ========== 
  services.openssh.enable = true;
  # services.xserver.xkb.layout = "us";

  # ========== System State ==========
  system.stateVersion = "26.05"; 

}
