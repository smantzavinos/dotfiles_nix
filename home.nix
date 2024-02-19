{config, pkgs, ...}: {
    home.username = "spiros";
    home.homeDirectory = "/home/spiros";
    home.stateVersion = "23.11"; # To figure this out you can comment out the line and see what version it expected.
    programs.home-manager.enable = true;

    # Allow unfree packages
    nixpkgs.config = {
        allowUnfree = true;
    };

    home.packages = [
      pkgs.cowsay
      pkgs.gh
      pkgs.jetbrains-mono
      pkgs.font-awesome
      pkgs.emacs-all-the-icons-fonts
      # pkgs.awesome-terminal-fonts
      pkgs.material-icons
      pkgs.weather-icons
      pkgs.fd
      pkgs.lshw
      pkgs.fzf
      pkgs.fzf-zsh
      pkgs.tmux
      pkgs.zsh-powerlevel10k
      pkgs.zplug
      pkgs.oh-my-zsh
      pkgs.alacritty
      pkgs.google-chrome
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    # Use Zplug for plugin management
    initExtraBeforeCompInit = ''
      source ${pkgs.zplug}/share/zplug/init.zsh

      # Load Powerlevel10k theme
      zplug "romkatv/powerlevel10k", as:theme, depth:1

      # source ${pkgs.zplug}/share/zplug/init.zsh

      # Load the Zplug plugins
      zplug "plugins/git", from:oh-my-zsh
      zplug "plugins/tmux", from:oh-my-zsh
      zplug "asdf-vm/asdf", use:"asdf.plugin.zsh"
      zplug "junegunn/fzf", as:command, use:"bin/*", hook-build:"./install --bin"
      zplug "Aloxaf/fzf-tab", defer:2

      # Install plugins if there are plugins that have not been installed yet
      if ! zplug check --verbose; then
          printf "Install? [y/N]: "
          if read -q; then
              echo; zplug install
          fi
      fi

      # Load plugins and themes
      zplug load
    '';

    # Source the Powerlevel10k configuration if it exists
    initExtra = ''
      [[ ! -f ${"~/dotfiles/zsh/.p10k.zsh"} ]] || source ${"~/dotfiles/zsh/.p10k.zsh"}
    '';
  };

  xdg.configFile."alacritty/alacritty.yml".text = ''
    shell:
      program: /home/spiros/.nix-profile/bin/tmux
      args:
        - new-session
        - zsh
  '';

}
