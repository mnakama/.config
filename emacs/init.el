(require 'package)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)


(setq custom-file "~/.config/emacs/custom.el")
(load custom-file 'noerror)

(require 'go-mode)
(require 'ivy)
(require 'evil)
(evil-mode t)

(require 'evil-magit)

; lookups:
;(lookup-key evil-motion-state-map "j")
;(lookup-key evil-ex-completion-map ":")

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(setq ivy-initial-inputs-alist nil)
(setq-default tab-width 4) 

(add-hook 'before-save-hook #'gofmt-before-save) 

(define-key evil-normal-state-map "\C-s" 'save-buffer)
(define-key evil-normal-state-map " gs" 'magit-status)
(define-key evil-normal-state-map " gl" 'magit-log-all)
(define-key evil-normal-state-map " gg" 'magit-log-all-branches)
(define-key evil-normal-state-map " gd" 'magit-diff-unstaged)
(define-key evil-normal-state-map " gD" 'magit-diff-staged)
(define-key evil-normal-state-map " gw" 'magit-diff-working-tree)

;(global-set-key "\M-x" 'execute-extended-command)
(global-set-key "\M-x" 'smex)

(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
;(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-r") 'counsel-minibuffer-history)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
