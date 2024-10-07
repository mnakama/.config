{ pkgs, config, ...}:

# https://nix-community.github.io/home-manager/options.xhtml
# file:///etc/nixos/lib/Home%20Manager%20Configuration%20Options.xhtml
let
  runtime-dir = "/run/user/1000";
in {
  nixpkgs.config.allowUnfree = true;

  home = {
    stateVersion = "22.11";

    sessionPath = [
      "$HOME/.local/bin"
      "$HOME/Sync/bin"
      "$HOME/go/bin"
      "$HOME/SpiderOak Hive/Programs/Python"
    ];

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      MPD_HOST = "$XDG_RUNTIME_DIR/mpd/socket";
      MOZ_USE_XINPUT2 = 1; # hi-res mousewheel scrolling in firefox
    };

    shellAliases = {
      ls = "ls --color=auto -N";
      grep = "grep --color=auto";
      vixb = "$EDITOR ${config.xdg.configHome}/X/xbindkeysrc && killall xbindkeys && ${config.xdg.configHome}/autostart-pre/*xbindkeys";
      vial = "$EDITOR ${config.xdg.configHome}/zsh/alias && source ${config.xdg.configHome}/zsh/alias";
      vihk = "cd ~/projects/xhotkey && $EDITOR xhotkey.c && make && systemctl --user restart xhotkey";
      bl = ''pls sh -c "cat > /sys/class/backlight/intel_backlight/brightness"'';

      pac=''super pacman'';
      pacs=''pacman -Ss --color=always'';
      pacu=''super pacman -Syu'';
      pacget=''curl -L -O https://aur.archlinux.org/cgit/aur.git/snapshot/package_name.tar.gz'';
      pacorph=''super pacman -R $(pacman -Qdtq)'';
      s=''super'';
      u=''suid'';
      d=''pls'';
      v=''nvim'';
      e=''emacs'';
      start=''super systemctl start'';
      stop=''super systemctl stop'';
      restart=''super systemctl restart'';
      sstatus=''super systemctl status'';

      rip=''ssh fc00::1 -p 26 "ip ad show dev eth0 |egrep -o ''\''''inet [0-9.]+''\''''|cut -d''\'''' ''\'''' -f2 |tr -d \"\n\"" 2>/dev/null'';
      wip="curl -o - http://wtfismyip.com/text";

      o=''ls'';
      oo=''ls -lh'';
      c=''LESS="-cR" less'';
      C=''nvim "+set nonu" -R'';
      pd=''pushd'';
      p=''popd'';

      ssh-all="ssh-add ~/.ssh/session-keys.d/*";

      n="nix-shell";
      b="nix-build";

      k=''kubectl'';
      kc=''k config use-context'';
      kcg=''k config get-contexts'';
      kcmv=''k config rename-context'';
      kp=''k get pods'';
      pods=''k get pods'';
      kl=''k logs'';
      krs=''k rollout status deploy'';

      g=''git'';
      ga=''git add'';
      # stage without whitespace changes. source: https://stackoverflow.com/a/45486981
      gaw="git diff -U0 -w --no-color | git apply --cached --ignore-whitespace --unidiff-zero -";
      gai=''clear; git add --interactive'';
      gap=''clear; git add -p'';
      gb=''git branch'';
      gbb=''git branch --format "%(HEAD) %(align:width=30)%(refname:short)%(end) %(align:width=20)%(authorname)%(end) %(align:width=34)%(authoremail)%(end) %(authordate:short)"'';
      gc=''git commit'';
      gca=''git commit --amend'';
      gch=''git checkout'';
      gd=''LESS="-cRS" git diff'';
      gdc=''LESS="-cRS" git diff --cached'';
      gf=''git fetch -p'';
      gg=''LESS="-cRS" git log --graph --oneline'';
      gga=''LESS="-cRS" git log --graph --oneline --all'';
      gl=''LESS="-cRS" git log'';
      gm=''git merge'';
      gp=''git pull'';
      gpush=''git push'';
      gs=''git status -s'';
      gst=''git stash'';
      gstl=''git stash list'';
      gstp=''git stash pop'';
      gsts=''git stash show'';

      hpl=''hub pr list'';
      hps=''hub pr show'';
      hpc=''hub pr checkout'';
      hpp=''hub pull-request'';

      hq   = "hg qseries -s";
      hqp  = "hg qpop";
      hqpu = "hg qpush";
      hqpm = "hg qpush --move";
      hl   = "hg log";
      hlp  = "hg log -l 1 -p";
      hd   = "hg diff";
      hgg  = "hg log -G";
      hh   = "hg log -l 1 --template '{node}' -r ."; # hg hash of current commit
      hhr  = "hg log -l 1 --template '{node}' -r"; # hg hash of any commit

      dk=''docker'';
      di=''docker image ls'';
      dp=''docker ps'';
      dps=''docker ps -a'';
      dclean=''docker system prune --volumes -fa'';
      dkc="docker compose";

      lt=''go test ./...'';
      lti=''go test ./... -tags=integration count=1'';
      lb=''go build'';
      lr=''go run .'';

      cbf=''gcloud builds log --stream $(gcloud builds list --ongoing --limit=1 | tail -1|cut -f1 -d" ")'';
      cbff=''gcloud builds log --stream $(gcloud builds list --limit=1 | tail -1|cut -f1 -d" ")'';
      cb=''gcloud builds log --stream'';
      cbl=''gcloud builds list --limit 10'';

      ccl=''gcloud compute ssl-certificates list'';
      ccd=''gcloud compute ssl-certificates delete'';
      cil=''gcloud compute addresses list'';

      abcde=''abcde -P -c ${config.xdg.configHome}/abcde.conf'';
      wnas=''wol d0:50:99:7d:59:c0'';

      unifi=''docker run --rm --init -p 8880:8880 -p 8080:8080 -p 8443:8443 -p 8843:8843 -p 3478:3478/udp -p 10001:10001/udp -e TZ='America/New_York' -v ~/unifi:/unifi --name unifi jacobalberty/unifi:stable'';

      rvnc=''vncviewer -encodings "copyrect tight hextile zlib corre rre raw" -x11cursor -compresslevel 9'';
      xpraattach=''xpra attach tcp:localhost:5000 --encoding png --no-microphone --no-speaker --no-pulseaudio &'';
      rd=''rdesktop -x b -a 16 -N -K -k en-dv -g 1488x881'';
      rd11=''rdesktop -x lan -a 16 -N -K -k en-dv -g 1488x881'';

      windows=''nice qemu-kvm -soundhw sb16 -m 128 -localtime -usbdevice tablet -net nic,model=rtl8139 -net user -monitor stdio'';

      mt=''mount | column -t'';
      xrecord=''ffmpeg -f x11grab -s wxga -r 25 -i :0.0 -qscale 9 /tmp/out.mpg'';

      # source: https://wiki.archlinux.org/title/Webcam_setup#mpv
      camview="mpv --profile=low-latency --untimed"; # av://v4l2:/dev/video4

      # source: https://flathub.org/apps/hu.irl.cameractrls
      camctl="hu.irl.cameractrls"; # installed via flatpack

      # Games;
      glhack=''glhack --mode 1600x900'';
      nestv="DISPLAY=:0.1 SDL_AUDIODRIVER=alsa AUDIODEV=hdmi fceux";
      eve=''WINEARCH=win32 wine /mnt/windows/Games\ \(x86\)/Eve\ Online/eve'';
      runeve=''WINEARCH=win32 wine /mnt/windows/Games\ \(x86\)/Eve\ Online/bin/ExeFile'';
      eso=''WINEARCH=win32 WINEPREFIX=${config.xdg.dataHome}/wineprefixes/elderscrollsonline wine "C:\Program Files\Zenimax Online\Launcher\Bethesda.net_Launcher.exe"'';
      esoplay=''WINEARCH=win32 WINEPREFIX=${config.xdg.dataHome}/wineprefixes/elderscrollsonline wine "C:\Program Files\Zenimax Online\The Elder Scrolls Online\game\client\eso.exe"'';
      darkforces=''dosbox "/media/windows/Program Files (x86)/Steam/SteamApps/common/Dark Forces/Game"'';

      # linux head tracking;
      ltrack=''ltr_pipe --format-uinput-abs --output-file=/dev/uinput'';
    };
  };

  programs = {
    emacs = {
      enable = true;
      extraPackages = epkgs: with epkgs; [
        adoc-mode
        counsel
        direnv
        dockerfile-mode
        dracula-theme
        elpy
        evil
        evil-collection
        evil-surround
        flycheck
        flycheck-flow
        git-link
        go-mode
        go-snippets
        go-tag
        ivy
        ivy-posframe
        jq-mode
        js2-mode
        kubernetes
        kubernetes-evil
        magit
        markdown-mode
        monky
        nix-mode
        org-jira
        php-mode
        plantuml-mode
        puppet-mode
        py-isort
        pycoverage
        python-pytest
        request
        restclient
        smartparens
        swiper
        telephone-line
        typescript-mode
        undo-tree
        use-package
        yaml-mode
        yasnippet

        # copilot deps
        dash
        editorconfig
        s
      ];
    };

    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      # trace: warning: matt profile: The option `programs.zsh.enableSyntaxHighlighting' defined in `/etc/nixos/lib/mod/desktop.nix' has been renamed to `programs.zsh.syntaxHighlighting.enable'.
      syntaxHighlighting.enable = true;
      enableVteIntegration = true;
      defaultKeymap = "viins";
      autocd = true;
      history = {
        ignoreDups = true;
        ignoreSpace = true;
        path = "${config.home.homeDirectory}/.histfile";
        size = 1500;
        save = 1000;
        share = false;
      };
      localVariables = {
        PROMPT = ''%m %F{cyan}%~%(1j. %F{yellow}%j%f.)%(0?.. %F{9}%?%f%b)%F{magenta}%#%f '';
        KEYTIMEOUT = 1;
      };
      loginExtra = ''
        if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
          export XAUTHORITY="$XDG_RUNTIME_DIR/xauthority"
          sway || sx
        fi
      '';
      initExtra = builtins.readFile "${config.xdg.configHome}/zsh/zshrc";
    };

    fish = {
      enable = true;
      shellInit = ''
        fish_vi_key_bindings
      '';
    };

    git = {
      enable = true;
      userName = "Matt Nakama";
      signing = {
        key = "21050986B2E83B8A";
      };
      aliases = {
        a = "add";
        ai = "add --interactive";
        ap = "add -p";
        b = "branch";
        c = "commit";
        ca = "commit --amend";
        ch = "checkout";
        d = "diff";
        dc = "diff --cached";
        f = "fetch -p";
        g = "log --graph --oneline";
        ga = "log --graph --oneline --all";
        l = "log";
        m = "merge";
        p = "pull";
        s = "status -s";
        st = "stash";
        stl = "stash list";
        stp = "stash pop";
        sts = "stash show";
      };
      extraConfig = {
        url = { "git@github.com" = { insteadOf = "https://github.com/"; }; };
        github = { user = "mnakama"; };
        pull = { ff = "only"; };
        advice = { addIgnoredFile = false; };
        init = { defaultBranch = "main"; };
      };
    };

    mpv = {
      enable = true;
      config = {
        ao = "pipewire";
        vo = "gpu";
      };
    };

    browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    ssh = let nopw = {
      PasswordAuthentication = "no";
      KbdInteractiveAuthentication = "no";
    }; in {
      enable = true;
      controlMaster = "auto";
      controlPath = "${runtime-dir}/ssh_%r@%h:%p";
      hashKnownHosts = false;
      extraConfig = ''
        AddKeysToAgent yes
        EnableEscapeCommandline yes
      '';

      matchBlocks = {
        nas = {
          user = "matt";
          extraOptions = nopw;
        };

        nas-root = {
          user = "root";
          extraOptions = nopw;
        };

        nas-boot = {
          user = "root";
          hostname = "fc00::d250:99ff:fe7d:59c0";
          extraOptions = nopw;
        };

        sexy-arch = {
          user = "matt";
          extraOptions = nopw;
        };

        router = {
          user = "matt";
          port = 26;
          extraOptions = nopw;
        };

        hive-db = {
          user = "ubuntu";
          hostname = "k8s-postgres.hive.local";
          extraOptions = nopw;
        };

        devzero = {
          user = "gnuman";
          port = 58391;
          extraOptions = nopw;
        };

        vps = {
          user = "matt";
          port = 20332;
          extraOptions = nopw;
        };
      };
    };
  };

  xdg = {
    mime.enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = let browser = "firefox.desktop"; in {
        "application/xhtml+xml" = browser;
        "text/html" = browser;
        "text/xhtml" = browser;
        "text/xml" = browser;
        "x-scheme-handler/tg" = "userapp-Telegram Desktop-PPY401.desktop";
        "x-scheme-handler/postman" = "Postman.desktop";
      };
    };
  };

  systemd.user = {
    startServices = "legacy";
    sessionVariables = {
      XAUTHORITY = "$XDG_RUNTIME_DIR/xauthority";
      MOZ_USE_XINPUT2 = 1; # hi-res mousewheel scrolling in firefox
    };
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
    };

    # The option definition `services.password-store-sync' in `/etc/nixos/lib/mod/desktop.nix' no longer has any effect; please remove it.
    # Use services.git-sync instead.
    git-sync = {
      enable = true;
      repositories = {
        pass = {
          path = config.programs.password-store.settings.PASSWORD_STORE_DIR;
          uri = "matt@nas:~/password-store";
          interval = 3600; # 1 hour
        };
      };
    };
  };
}
