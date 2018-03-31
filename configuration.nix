# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/vda"; # or "nodev" for efi only

  # Connecting to the VPS via VNC can take a while
  boot.loader.timeout = 10;

  fileSystems."/" = {
    device = "/dev/vda3";
    fsType = "ext4";
  };

  networking.hostName = "vps-uk.rdnetto.net"; # Define your hostname.
  networking.wireless.enable = false;  # Enables wireless support via wpa_supplicant.

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_AU.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    wget neovim mosh tmux git zsh ripgrep fasd moreutils pv
    nix-index docker file tig psmisc
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Without this line, PATH will not be set correctly
  programs.zsh.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  users.extraUsers.root.shell = pkgs.zsh;
  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/jW6mek+KOPMvD4eH63mFCMRHKf7DZZSmjhITD6Qx9jYncBhBWytl0BoSNSNifUKTeIS/HHqnHj4BNjKdqOEIuly5GyskUUg9Y9F2rBjvblO7mKnEdRt3tAbP/yZwWhoi+YNbJ13/1yIrWNQxr4LU1LXL2yPKEmtIcCEa/910xBU2D0SSYJZWrQiWohbXeAsg2fqGU/MvWKNppUo4Ymo04ZRZAIt3TET2ehUhrL7EXWdz84wEHYFYZ6HbaXHOEyO2y6kK9r9I3EsAapXB5r6I6MBYJJ2jlwEs6jpujLfAHkvWFKbEeJWW5fxtweq/6GDq+jSTfoEIhGr5PvJUNTrJ reuben@phenom"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGhNuzkIv1X6bilLRxx4PmgTn0Dy0i69Yx9QsykMOvYSssxweX8Et7jreQ6gZd+DJ52FHTkgtwBK7haD+kbe2SFFvFuzF4aRGhtf5XxJGZK10my9ZQbUYA2Je/JEGBrNvzpNqbHp8a058RoWmPvFSsVAQc8rY7W92jfboOuuoj3cvgPyiLVLSVdq0ktmv07UdYrmL8hb1QVFQEI9jV9yoVKycQQ2MUCO1F6K8qSPQ4Ttb9E+DwQ7BrULrLeq1zHRw7HXdwYwG5iMbklXxrX/lwxKNByoXLAUX9LFjo1oaeYC6UGXrcnuStAN8gsOGlScLn9OzfM/aNosZ7yT+d/YCp reuben@yuki"
];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = false;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.extraUsers.guest = {
  #   isNormalUser = true;
  #   uid = 1000;
  # };

  # Increase per-user tmpdir size (/run/user/$UID)
  # Without this GHC fails to compile some packages
  services.logind.extraConfig= "RuntimeDirectorySize=4G";

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?


  virtualisation.docker.enable = true;
  users.users.root.extraGroups = ["docker"];
}
