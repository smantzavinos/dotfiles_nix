
{ pkgs, ... }:

{
  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.xserver =  {
    xkbOptions = "ctrl:nocaps";
  };

  # steam
  # TODO

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;
}
