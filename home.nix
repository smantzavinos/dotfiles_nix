{pkgs, ...}: {
    home.username = "spiros";
    home.homeDirectory = "/home/spiros";
    home.stateVersion = "23.11"; # To figure this out you can comment out the line and see what version it expected.
    programs.home-manager.enable = true;

    home.packages = [
      pkgs.cowsay
      pkgs.gh
      pkgs.jetbrains-mono
      pkgs.emacs-all-the-icons-fonts
      # pkgs.awesome-terminal-fonts
      pkgs.material-icons
      pkgs.weather-icons
      pkgs.fd
      pkgs.lshw
    ];

    programs.git = {
      enable = true;
      userName = "Spiros Mantzavinos";
      userEmail = "smantzavinos@gmail.com";
    };

    programs.neovim = {
      enable = true;
      vimAlias = true;
      # vim config not working correctly.
      # need a way to manage plugins
      extraConfig = ''
        source /home/spiros/vimfiles/_vimrc
      '';
    };

    programs.emacs = {
      enable = true;
      package = pkgs.emacs;
      extraConfig = ''
        (load-file "/home/spiros/dotfiles/.emacs.d/init_local.el")
      '';
    };
}
