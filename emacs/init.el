;;; init.el --- my config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(global-display-line-numbers-mode t)

(defvar show-paren-delay 0)
(show-paren-mode t)
(setq-default tab-width 4)
(setq-default sgml-basic-offset 4)
(setq inhibit-splash-screen t)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(require 'use-package)
(require 'use-package-ensure)
(setq use-package-always-ensure t)

(use-package dracula-theme)

(setq custom-file "~/.config/emacs/custom.el")
(load custom-file 'noerror)

(use-package telephone-line
  :config

  (setq telephone-line-primary-right-separator 'telephone-line-abs-left
		telephone-line-secondary-right-separator 'telephone-line-abs-hollow-left)
  (setq telephone-line-evil-use-short-tag nil)

  (telephone-line-mode 1))

; fix telephone-line after changing font size
;(telephone-line-separator-clear-cache telephone-line-abs-left)


(if (or (equal (system-name) "beast")
	    (equal (system-name) "mnakama-arch"))
  (set-frame-font "spleen:pixelsize=24:antialias=true:autohint=true" nil t)
(if (equal (system-name) "mattdesktop")
  (set-frame-font "spleen:pixelsize=32:antialias=true:autohint=true" nil t)))


(add-hook 'c-mode-common-hook (setq-default c-basic-offset 4
											 tab-width 4
											 indent-tabs-mode t))

(use-package go-mode
  :mode "\\.go\\'"
  :hook (before-save . gofmt-before-save))

(use-package go-tag)

(use-package gorepl-mode)

(use-package js2-mode
  :mode "\\.m?jsm?\\'"
  :config
  (add-to-list 'auto-mode-alist '("\\.m?jsm?\\'" . js2-mode))
  (add-hook 'js2-mode-hook 'flow-minor-enable-automatically))


(use-package flycheck
  :config (global-flycheck-mode))

(use-package flycheck-flow
  :after flycheck
  :config
  (flycheck-add-mode 'javascript-flow 'flow-minor-mode)
  (flycheck-add-mode 'javascript-eslint 'flow-minor-mode)
  (flycheck-add-next-checker 'javascript-flow 'javascript-eslint))

(use-package smart-tabs-mode
  :config
  (smart-tabs-insinuate 'javascript))

(use-package yasnippet
  :init
  (add-to-list 'load-path "~/.config/emacs/plugins/yasnippet")
  :config
  (yas-global-mode 1))

(use-package go-snippets)

(defun show-buffer-path ()
  (interactive)
  (message "%s" buffer-file-name))

(defun edit-emacs-config ()
  (interactive)
  (find-file "~/.config/emacs/init.el"))

(defun json-unpretty-print-buffer ()
  (interactive)
  (json-pretty-print-buffer t))

(require 'sql)

(use-package evil
  :init (setq evil-want-keybinding nil)
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
  (define-key evil-normal-state-map " gco" 'magit-commit)
  (define-key evil-normal-state-map " gch" 'magit-checkout)
  (define-key evil-normal-state-map " ghl" 'git-link)
  (define-key evil-visual-state-map " ghl" 'git-link)
  (define-key evil-normal-state-map " ec" 'edit-emacs-config)
  (define-key evil-normal-state-map " sm" 'sql-mysql)
  (define-key evil-normal-state-map " sp" 'sql-postgres)
  (define-key evil-normal-state-map " sc" 'sql-connect)
  (define-key evil-normal-state-map " ss" 'sql-save-connection)
  (define-key evil-normal-state-map " t" 'go-tag-add)
  (define-key evil-normal-state-map " T" 'go-tag-remove)
  (define-key evil-normal-state-map " k" 'kubernetes-overview)

  (evil-define-key 'normal js-mode-map " p" 'json-pretty-print-buffer)
  (evil-define-key 'normal js-mode-map " P" 'json-unpretty-print-buffer)
  )

(use-package kubernetes)
(use-package kubernetes-evil)

(use-package smartparens
  :config
  (require 'smartparens-config)
  (sp-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  :hook (prog-mode . smartparens-mode))

(use-package magit)
(use-package evil-collection
  :config
  (evil-collection-init))

(use-package evil-surround
  :ensure t
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
  :config
  (setq ivy-initial-inputs-alist nil)
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

;(global-set-key "\M-x" 'execute-extended-command)

;;; init.el ends here
