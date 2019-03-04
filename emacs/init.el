(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(global-display-line-numbers-mode t)

(setq show-paren-delay 0)
(show-paren-mode t)
(setq-default tab-width 4)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))
(setq package-enable-at-startup nil)
(package-initialize)

(setq custom-file "~/.config/emacs/custom.el")
(load custom-file 'noerror)

(require 'use-package)

(setq evil-want-keybinding nil)

(use-package telephone-line
  :config

  (setq telephone-line-primary-right-separator 'telephone-line-abs-left
		telephone-line-secondary-right-separator 'telephone-line-abs-hollow-left)
  (setq telephone-line-evil-use-short-tag nil)

  (telephone-line-mode 1))

; fix telephone-line after changing font size
;(telephone-line-separator-clear-cache telephone-line-abs-left)

(if (equal system-name "beast")
	(set-frame-font "spleen:pixelsize=24:antialias=true:autohint=true")
  (set-frame-font "spleen:pixelsize=32:antialias=true:autohint=true"))

(use-package go-mode
  :mode "\\.go\\'"
  :hook (before-save . gofmt-before-save))

;(add-hook 'before-save-hook 'gofmt-before-save)

(use-package js2-mode
  :mode "\\.m?jsm?\\'"
  :config
  (add-to-list 'auto-mode-alist '("\\.m?jsm?\\'" . js2-mode)))

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

(use-package evil
  :config
  (evil-mode t)
  ; missing vim keybinds
  (define-key evil-motion-state-map (kbd "g <up>") 'evil-previous-visual-line)
  (define-key evil-motion-state-map (kbd "g <down>") 'evil-next-visual-line)
  (define-key evil-normal-state-map "\C-g" 'show-buffer-path)

  ; my custom keybinds
  (define-key evil-normal-state-map "\C-s" 'save-buffer)
  (define-key evil-normal-state-map "\C-w\C-n" 'evil-window-vnew)
  (define-key evil-normal-state-map " gs" 'magit-status)
  (define-key evil-normal-state-map " gb" 'magit-blame)
  (define-key evil-normal-state-map " gl" 'magit-log-all)
  (define-key evil-normal-state-map " gg" 'magit-log-all-branches)
  (define-key evil-normal-state-map " gd" 'magit-diff-unstaged)
  (define-key evil-normal-state-map " gD" 'magit-diff-staged)
  (define-key evil-normal-state-map " gw" 'magit-diff-working-tree)
  (define-key evil-normal-state-map " ghl" 'git-link)
  (define-key evil-visual-state-map " ghl" 'git-link))

(use-package magit)
(use-package evil-magit)
(use-package evil-collection
  :config
  (evil-collection-init))

; lookups:
;(lookup-key evil-motion-state-map "j")
;(lookup-key evil-ex-completion-map ":")

(use-package smex)
(use-package swiper)
(use-package ivy
  :config
  (setq ivy-initial-inputs-alist nil)
  (ivy-mode t))

(use-package counsel)

(use-package ivy-posframe
  :config
  (setq ivy-display-function #'ivy-posframe-display-at-frame-bottom-left)
  (ivy-posframe-enable))

;(global-set-key "\M-x" 'execute-extended-command)
;(global-set-key "\M-x" 'smex)

(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
(define-key minibuffer-local-map (kbd "C-r") 'counsel-minibuffer-history)
