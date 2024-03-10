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
      # utils
      pkgs.cowsay
      pkgs.gh
      pkgs.fd
      pkgs.ripgrep
      pkgs.lshw
      pkgs.fzf
      pkgs.nix-prefetch-github

      # tmux
      pkgs.tmuxPlugins.cpu

      # zsh
      pkgs.zsh-powerlevel10k
      pkgs.zplug
      pkgs.oh-my-zsh
      pkgs.fzf-zsh

      # apps
      pkgs.google-chrome

      # epic games
      pkgs.lutris
      pkgs.wineWowPackages.full

    # fonts
      pkgs.nerdfonts
      pkgs.font-awesome
      pkgs.emacs-all-the-icons-fonts
      pkgs.material-icons
      pkgs.weather-icons
    ];

    # auto reload fonts so you don't need to execute `fc-cache -f -v` manually after install
    fonts.fontconfig.enable = true;

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

  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    shortcut = "a";
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
    extraConfig = ''
        # unbind C-b
        # set-option -g prefix C-a
        # bind-key C-a send-prefix

        # setw -g mouse on

        # # Set the time in milliseconds for which tmux waits after an escape is input to
        # # determine if it is part of a function or meta key sequences. The default is 500 milliseconds.
        # # At 500 this causes and annoying delay in vim.
        # set -sg escape-time 20

        # # VI keys for movement, selection, and copying
        # setw -g mode-keys vi
        # bind-key -T copy-mode-vi v send -X begin-selection
        # bind-key -T copy-mode-vi y send -X copy-selection-and-cancel

        # # Don't rename windows automatically
        # set-option -g allow-rename off

        # # Restore neovim sessions when restoring tmux sessions
        # set -g @resurrect-strategy-nvim 'session'

        # # Restore pane contents when restoring tmux sessions
        # set -g @resurrect-capture-pane-contents 'on'


        set -g status-right '#[fg=black,bg=color15] #{cpu_percentage}  %H:%M '
        run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
    '';
    };

  programs.alacritty = {
    enable = true;
    settings = {
      shell = {
        program = "${pkgs.zsh}/bin/zsh";
        args = [ "-c" "tmux attach || tmux new" ];
      };
      font = {
        size = 10.0;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font";
          style = "Italic";
        };
      };
    };
  };

}
