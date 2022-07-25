{ pkgs, config, ...}:

# https://nix-community.github.io/home-manager/options.html

{
  targets.genericLinux.enable = true;
  nixpkgs.config.allowUnfree = true;

  programs = {
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    };

    zsh = {
      enable = true;
      initExtra = ". ${config.xdg.configHome}/zsh/zshrc";
    };
  };

  systemd.user = {
    startServices = "legacy";
    systemctlPath = "/usr/bin/systemctl";
  };

  services = {
    dunst = {
      enable = true;

      settings = {
        global = {
          monitor = 0;
          follow = "none";
          geometry = "300x5-30+20";
          indicate_hidden = true;
          shrink = false;
          transparency = 0;
          notification_height = 0;
          separator_height = 2;
          padding = 8;
          horizontal_padding = 8;
          frame_width = 3;
          frame_color = "#aaaaaa";
          separator_color = "frame";
          sort = true;
          idle_threshold = 120;
          font = "Monospace 8";
          line_height = 0;
          markup = "full";
          format = "<b>%s</b>\n%b";
          alignment = "left";
          show_age_threshold = 60;
          word_wrap = true;
          ellipsize = "middle";
          ignore_newline = false;
          stack_duplicates = true;
          hide_duplicate_count = false;
          show_indicators = true;
          icon_position = "left";
          max_icon_size = 32;
          sticky_history = true;
          history_length = 20;


          always_run_script = true;
          title = "Dunst";
          class = "Dunst";
          startup_notification = false;
          force_xinerama = false;
        };

        urgency_low = {
          background = "#222222";
          foreground = "#888888";
          timeout = 10;
        };
        urgency_normal = {
          background = "#285577";
          foreground = "#ffffff";
          timeout = 10;
        };
        urgency_critical = {
          background = "#900000";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 0;
        };
      };
    };

    gpg-agent = {
      enable = true;
      #enableZshIntegration = true;
    };

    redshift = {
      enable = true;
      latitude = 43.0;
      longitude = -74.0;
    };
  };

  home.packages = [
    pkgs.abcde
    pkgs.aspell
    pkgs.aspellDicts.en
    pkgs.aspellDicts.en-computers
    pkgs.alacritty
    pkgs.alsa-utils
    pkgs.amfora
    pkgs.ansible
    pkgs.asciidoctor
    pkgs.audacious
    pkgs.audacity
    pkgs.beep
    pkgs.calibre
    pkgs.cdparanoia
    pkgs.claws-mail
    pkgs.dia
    pkgs.discord
    pkgs.dmenu
    pkgs.element-desktop
    pkgs.emacs
    pkgs.epdfview
    pkgs.firefox
    pkgs.gnupg
    pkgs.handbrake
    pkgs.htop
    pkgs.hugo
    pkgs.iftop
    pkgs.inkscape
    pkgs.iotop
    pkgs.mosh
    pkgs.mpd
    pkgs.mpv
    pkgs.neovim
    pkgs.nmap
    pkgs.p7zip
    pkgs.picom
    pkgs.pv
    pkgs.pwgen
    pkgs.rocketchat-desktop
    pkgs.scrot
    pkgs.smtube
    pkgs.spotify
    pkgs.strace
    pkgs.stunnel
    pkgs.tcpdump
    pkgs.tigervnc
    pkgs.unrar
    pkgs.unzip
    pkgs.vlc
    pkgs.webfs
    pkgs.wireshark-qt
    pkgs.wol
    pkgs.x11vnc
    pkgs.xbanish
    pkgs.yt-dlp
    pkgs.zbar
  ];
    #pkgs.sassc
    #pkgs.jq
    #pkgs.ngrok
    #pkgs.xonotic
    #pkgs.mpc
    #pkgs.ansible-core
    #"pkgs.6tunnel"
}
