;;; init.el --- my config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(global-display-line-numbers-mode t)
(setq-default display-line-numbers-grow-only t
			  display-line-numbers-width 3)

(defvar show-paren-delay 0)
(show-paren-mode t)
(setq-default tab-width 4
			  sgml-basic-offset 4)
(setq inhibit-splash-screen t)
(blink-cursor-mode 0)

(setq ring-bell-function 'ignore)

(setq auth-sources '("~/.authinfo.gpg"))

; enable mouse in console
(xterm-mouse-mode t)

(setq-default buffer-file-coding-system 'utf-8-unix)

(when (eq window-system 'ns)
  ;(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;maximize/"zoom"
  (add-hook 'window-setup-hook 'toggle-frame-fullscreen t) ;full-screen
  (setenv "PATH" (concat "/usr/local/bin" ":" (getenv "PATH")))
)
(when (eq window-system 'w32)
  (add-hook 'window-setup-hook 'toggle-frame-maximized)
  (setq-default tramp-default-method "sshx"))

(setq backup-directory-alist
  `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
  `((".*" ,temporary-file-directory t)))

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(use-package ruff-format
  :config
  (add-hook 'python-mode-hook 'ruff-format-on-save-mode))

;(add-to-list 'load-path "~/.config/emacs/lisp")
(eval-when-compile
  (require 'use-package))

; only needed on systems without nix/home-manager
;(require 'use-package-ensure)
;(setq use-package-always-ensure t)

(use-package dracula-theme)

(setq custom-file "~/.config/emacs/custom.el")
(load custom-file 'noerror)

(use-package telephone-line
  :custom
  (telephone-line-primary-right-separator 'telephone-line-abs-left)
  (telephone-line-secondary-right-separator 'telephone-line-abs-hollow-left)
  (telephone-line-evil-use-short-tag nil)
  :config
  (telephone-line-mode 1))

; fix telephone-line after changing font size
;(telephone-line-separator-clear-cache telephone-line-abs-left)


(if (equal (system-name) "rusty")
  ;(set-frame-font "spleen:pixelsize=16:antialias=false:autohint=false" nil t)
  (set-face-attribute 'default nil :height 100)
  (if (or (equal (system-name) "mattdesktop") (equal (system-name) "beast"))
    (set-frame-font "spleen:pixelsize=32:antialias=true:autohint=true" nil t))
  (if (equal (system-name) "mnakama-MBPro")
    (set-face-attribute 'default nil :height 190))

  ; Set font size for skytap WSL
  ; https://stackoverflow.com/questions/294664/how-to-set-the-font-size-in-emacs
  (if (equal (system-name) "nixos")
    (set-face-attribute 'default nil :height 150))
)

(add-hook 'c-mode-common-hook (setq-default c-basic-offset 4
											 tab-width 4
											 indent-tabs-mode t))

(use-package request)

(use-package direnv
  :config
  (direnv-mode))

(use-package jq-mode)
(use-package restclient
  :config
  (setq-default restclient-inhibit-cookies t)
  (add-to-list 'auto-mode-alist '("\\.rest\\'" . restclient-mode)))

(use-package yaml-mode
  :mode "\\.yaml\\'")

(use-package adoc-mode
  :mode "\\.adoc\\'")

(use-package plantuml-mode
  :mode "\\.puml\\'"
  :init
  (setq-default plantuml-executable-path "/etc/profiles/per-user/matt/bin/plantuml")
  (setq-default plantuml-default-exec-mode 'executable)
)

(use-package go-mode
  :mode "\\.go\\'"
  :hook (before-save . gofmt-before-save))

(use-package elpy
  :mode ("\\.py\\'" . 'python-mode)
  :init (advice-add 'python-mode :before 'elpy-enable))

;(use-package py-isort
;  :mode ("\\.py\\'" . 'python-mode)
;  :config (add-hook 'before-save-hook 'py-isort-before-save))

;(setq py-python-command "python"
;	  python-shell-interpreter "python")

(use-package go-tag
  :after go-mode)

;(use-package gorepl-mode)

(use-package js2-mode
  :mode "\\.m?jsm?\\'")

(use-package nix-mode
  :mode "\\.nix\\'")

(use-package flycheck
  :config
  (global-flycheck-mode)
  ; fix direnv+flycheck issue with workaround found here:
  ; https://github.com/wbolster/emacs-direnv/issues/17
  (setq flycheck-executable-find
        (lambda (cmd) (direnv-update-environment default-directory) (executable-find cmd))))

(use-package flycheck-flow
  :after flycheck js2-mode
  :config
  (flycheck-add-mode 'javascript-flow 'flow-minor-mode)
  (flycheck-add-mode 'javascript-eslint 'flow-minor-mode)
  (flycheck-add-next-checker 'javascript-flow 'javascript-eslint))

(use-package flycheck-pyre
  :after flycheck
  ;:init
  ;(add-hook 'flycheck-mode-hook #'flycheck-pyre-setup)
  :config
  (flycheck-pyre-setup)
  )

(use-package yasnippet
  :init
  (add-to-list 'load-path "~/.config/emacs/plugins/yasnippet")
  :config
  (yas-global-mode 1))

(use-package go-snippets
  :after go-mode)

(defun show-buffer-path ()
  (interactive)
  (message "%s" buffer-file-name))

(defun edit-emacs-config ()
  (interactive)
  (find-file "~/.config/emacs/init.el"))

(defun edit-home-manager-config ()
  (interactive)
  (find-file "~/.config/nixpkgs/home.nix"))

(defun edit-nixos-config ()
  (interactive)
  (find-file "/etc/nixos/lib"))

(defun nixos-rebuild-switch ()
  (interactive)
  (async-shell-command "sudo nixos-rebuild switch"))

(defun json-unpretty-print-buffer ()
  (interactive)
  (json-pretty-print-buffer t))

; paste from terminal:
; 1. (Emacs mode) C-u C-y
; 2. M-x electric-indent-mode
; https://stackoverflow.com/questions/986592/any-emacs-command-like-paste-mode-in-vim

; copy to clipboard via terminal
; https://stackoverflow.com/a/65657463
(defun yank-to-clipboard ()
  "Use ANSI OSC 52 escape sequence to attempt clipboard copy"
  (interactive)
  (send-string-to-terminal
    (format "\033]52;c;%s\a"
	  (base64-encode-string
	    (encode-coding-string
	      (substring-no-properties
	        (nth 0 kill-ring)) 'utf-8) t))))

(defun coverage ()
  "Show test coverage for current file, dependent on major mode"
  (interactive)

  (if (eq major-mode 'go-mode)
    (go-coverage "coverage.out")

	; else
    (if (eq major-mode 'python-mode)
      (print "python TBD")
    )
  )
)

; https://stackoverflow.com/a/12763858
(add-hook 'prog-mode-hook #'hs-minor-mode)


(require 'sql)

(use-package undo-tree
  :config
  (global-undo-tree-mode t)
  :custom
  (undo-tree-auto-save-history nil))

(use-package prettier-js
  :config
  (add-hook 'js2-mode-hook 'prettier-js-mode))

(use-package evil
  :after undo-tree
  :init
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-tree)
  :config
  (evil-mode t)
  ; missing vim keybinds
  (define-key evil-motion-state-map (kbd "g <up>") 'evil-previous-visual-line)
  (define-key evil-motion-state-map (kbd "g <down>") 'evil-next-visual-line)
  (define-key evil-normal-state-map "\C-g" 'show-buffer-path)

  ; my custom keybinds
  (define-key evil-normal-state-map "\C-s" 'save-buffer)
  (define-key evil-normal-state-map "\C-w\C-n" 'evil-window-vnew)
  (define-key evil-normal-state-map " m" 'magit-dispatch)
  (define-key evil-normal-state-map " ga" 'magit-stage-file)
  (define-key evil-normal-state-map " gs" 'magit-status)
  (define-key evil-normal-state-map " gb" 'magit-blame)
  (define-key evil-normal-state-map " gl" 'magit-log-all)
  (define-key evil-normal-state-map " gg" 'magit-log-all-branches)
  (define-key evil-normal-state-map " gd" 'magit-diff-unstaged)
  (define-key evil-normal-state-map " gD" 'magit-diff-staged)
  (define-key evil-normal-state-map " gw" 'magit-diff-working-tree)
  (define-key evil-normal-state-map " gr" 'magit-run)
  (define-key evil-normal-state-map " gco" 'magit-commit)
  (define-key evil-normal-state-map " gch" 'magit-checkout)
  (define-key evil-normal-state-map " ghl" 'git-link)
  (define-key evil-visual-state-map " ghl" 'git-link)
  (define-key evil-normal-state-map " ec" 'edit-emacs-config)
  (define-key evil-normal-state-map " nh" 'edit-home-manager-config)
  (define-key evil-normal-state-map " nc" 'edit-nixos-config)
  (define-key evil-normal-state-map " ns" 'nixos-rebuild-switch)
  (define-key evil-normal-state-map " ol" 'sort-lines)
  (define-key evil-visual-state-map " ol" 'sort-lines)
  (define-key evil-normal-state-map " sm" 'sql-mysql)
  (define-key evil-normal-state-map " sp" 'sql-postgres)
  (define-key evil-normal-state-map " sc" 'sql-connect)
  (define-key evil-normal-state-map " ss" 'sql-save-connection)
  (define-key evil-normal-state-map " t" 'go-tag-add)
  (define-key evil-normal-state-map " T" 'go-tag-remove)
  (define-key evil-normal-state-map " k" 'kubernetes-overview)

  ; tests
  (define-key evil-normal-state-map " U" 'python-pytest-dispatch)
  (define-key evil-normal-state-map " ur" 'python-pytest-repeat)
  (define-key evil-normal-state-map " uf" 'python-pytest-file-dwim)
  (define-key evil-normal-state-map " uu" 'python-pytest-function-dwim)
  (define-key evil-normal-state-map " ud" 'python-pytest-last-failed)


  ; run emacs compile, which calls make
  ; https://www.emacswiki.org/emacs/CompileCommand
  (define-key evil-normal-state-map " c" 'compile)

  ; coverage (see definition above)
  (define-key evil-normal-state-map " C" 'coverage)

  ; hg / monky
  (define-key evil-normal-state-map " hs" 'monky-status)
  (define-key evil-normal-state-map " H" 'monky-hg-command)
  (define-key evil-normal-state-map " hh" 'monky-hg-command)

  (evil-define-key 'normal js-mode-map " p" 'json-pretty-print-buffer)
  (evil-define-key 'normal js-mode-map " P" 'json-unpretty-print-buffer)

  (add-hook 'evil-local-mode-hook 'turn-on-undo-tree-mode)
  )

(use-package kubernetes)
(use-package kubernetes-evil
  :after kubernetes evil)

(use-package smartparens
  :config
  (require 'smartparens-config)
  (sp-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  :hook (prog-mode . smartparens-mode))

(use-package magit
  :config
  (keymap-set magit-mode-map "." #'forge-dispatch))

(use-package git-link)

(use-package forge
  :after magit)

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(setq auto-revert-check-vc-info t)
(setq auto-revert-interval 60)

; lookups:
;(lookup-key evil-motion-state-map "j")
;(lookup-key evil-ex-completion-map ":")

(use-package swiper
  :bind
  ("\C-s" . swiper))

(use-package ivy
  :custom
  (ivy-initial-inputs-alist nil)
  :config
  (ivy-mode t)
  (global-set-key (kbd "C-c C-r") 'ivy-resume))

(use-package counsel
  :bind
  (
   ("M-x" . counsel-M-x)
   ("C-x C-f" . counsel-find-file)
   ("<f1> f" . counsel-describe-function)
   ("<f1> v" . counsel-describe-variable)
   ("<f1> l" . counsel-find-library)
   ("<f2> i" . counsel-info-lookup-symbol)
   ("<f2> u" . counsel-unicode-char)
   ("C-c g" . counsel-git)
   ("C-c j" . counsel-git-grep)
   ("C-c k" . counsel-ag)
   ("M-y" . counsel-yank-pop)
   (:map minibuffer-local-map ("C-r" . counsel-minibuffer-history))))

(use-package ivy-posframe
  :config
  (defvar ivy-display-function #'ivy-posframe-display-at-frame-bottom-left))

(when (string-match "nixos" (system-name))
	; enable copilot on the work machine
	; https://robert.kra.hn/posts/2023-02-22-copilot-emacs-setup/
	;(use-package copilot)
	;  :load-path

	;  (lambda () (expand-file-name "copilot.el" user-emacs-directory)))
	;; don't show in mode line
	;:diminish

	(use-package copilot)
	(use-package org-jira
	  :config
	  (setq jiralib-url "https://skytap.atlassian.net"))
)

;(global-set-key "\M-x" 'execute-extended-command)

;;; init.el ends here
