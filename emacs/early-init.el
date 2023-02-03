;;; early-init.el --- my config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

; startup performance enhancements
(setq gc-cons-threshold (eval-when-compile (* 256 1024 1024)))

(let ((saved-alist file-name-handler-alist))
  (defun post-init-restore ()
	(setq gc-cons-threshold (eval-when-compile (* 16 1024 1024))
		  file-name-handler-alist saved-alist))
  (add-hook 'after-init-hook #'post-init-restore))

(setq file-name-handler-alist nil)

(require 'package)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
;(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

;;; early-init.el ends here
