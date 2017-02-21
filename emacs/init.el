;;; init.el --- My configuration.
;; 
;;; Commentary:
;; 
;; My Emacs configuration.
;; 
;; -*- coding: utf-8; lexical-binding: t -*-
;; 
;;; Code:

(package-initialize)
(require 'cask (concat
                (getenv "HOME")
                (if (eq window-system 'w32)
                    "\\.cask\\cask.el"
                  "/.cask/cask.el")))
(cask-initialize)

(defconst geek/dvorak-home-row '(?a ?o ?e ?u ?i ?d ?h ?t ?n ?s ?-)
  "The Dvorak layout's home row.")

(setq-default indent-tabs-mode nil
              tab-always-indent t
              tab-width 4
              vc-follow-symlinks t
              mode-line-default-help-echo nil
              use-file-dialog nil)

(setq auto-save-default nil
      make-backup-files nil
      inhibit-startup-screen t
      initial-major-mode 'fundamental-mode)

(defalias 'yes-or-no-p 'y-or-n-p
  "Use 'y' and 'n' to answer yes/no questions, like a sane human being.")

(when window-system
  (scroll-bar-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (blink-cursor-mode -1)
  (column-number-mode 1)
  (set-frame-font "Source Code Pro 11"))

(use-package zerodark-theme 
  :init (load-theme 'zerodark t))

(use-package shackle
  :init
  (setq shackle-rules '(("*Help*" :select t :size 20 :align 'below)
                        ("*Warnings*" :select t :size 20 :align 'below)))
  (shackle-mode t))

(use-package smooth-scrolling
  :init (smooth-scrolling-mode t))

(use-package idle-highlight-mode
  :init (setq idle-highlight-idle-time 0.75))

(use-package company
  :bind (:map company-active-map
              ("C-h" . company-select-next)
              ("C-t" . company-select-previous))
  :init (setq company-show-numbers t
              company-idle-delay 0.1
              company-auto-complete nil))

(use-package nlinum
  :config (set-face-attribute 'linum nil :height 0.85))

(use-package highlight-indent-guides
  :init (setq highlight-indent-guides-method 'character))

(use-package drag-stuff
  :bind (("M-t" . drag-stuff-up)
         ("M-h" . drag-stuff-down))
  :init
  (drag-stuff-global-mode t))

;;
;; `ivy'
;; 

(use-package ivy :demand
  :bind (:map ivy-minibuffer-map
              ("C-h" . ivy-next-line)
              ("C-t" . ivy-previous-line))
  :init (setq ivy-height 20
              ivy-wrap t)
  :config (ivy-mode t))

;;
;; `evil'
;;

(use-package evil
  :bind
  (:map
   evil-inner-text-objects-map
   ("a" . evil-inner-arg)
   :map
   evil-outer-text-objects-map
   ("a" . evil-outer-arg)
   :map
   evil-normal-state-map
   ("d" . evil-backward-char)
   ("n" . evil-forward-char)
   ("h" . evil-next-visual-line)
   ("t" . evil-previous-visual-line)
   ("j" . evil-snipe-X)
   ("k" . evil-delete)
   ("K" . evil-delete-line)
   ("l" . evil-search-next)
   ("L" . evil-search-previous)
   ("D" . evil-backward-arg)
   ("N" . evil-forward-arg)
   ("U" . evil-jump-out-args)
   :map evil-visual-state-map
   ("d" . evil-backward-char)
   ("n" . evil-forward-char)
   ("h" . evil-next-visual-line)
   ("t" . evil-previous-visual-line)
   ("j" . evil-find-char-to)
   ("k" . evil-delete)
   ("K" . evil-delete-line)
   :map evil-motion-state-map
   ("d" . evil-backward-char)
   ("n" . evil-forward-char)
   ("h" . evil-next-visual-line)
   ("t" . evil-previous-visual-line)
   ("j" . evil-find-char-to)
   ("k" . evil-delete)
   ("K" . evil-delete-line))
  :init
  (setq evil-echo-state nil
        evil-want-C-u-scroll t
        evil-find-skip-newlines t
        evil-normal-state-tag "N"
        evil-insert-state-tag "I"
        evil-visual-state-tag "V"
        evil-emacs-state-tag "E"
        evil-operator-state-tag "O"
        evil-motion-state-tag "M"
        evil-replace-state-tag "R"
        evil-default-cursor (face-attribute 'cursor
                                            :background
                                            nil
                                            'default)
        evil-normal-state-cursor 'box
        evil-insert-state-cursor 'bar
        evil-operator-state-cursor '(hbar . 2)
        evil-visual-state-cursor `(,(face-attribute 'shadow
                                                    :background
                                                    nil
                                                    'default)
                                   box)
        evil-emacs-state-cursor `(,(face-attribute 'font-lock-builtin-face
                                                   :foreground
                                                   nil
                                                   'default)
                                  bar))
  (evil-mode 1))

(use-package evil-args
  :commands (evil-forward-arg evil-backward-arg))

(use-package evil-lispy
  :config (setq evil-lispy-state-tag               "L"
                lispy-avy-keys                     geek/dvorak-home-row
                lispy-comment-use-single-semicolon t
                lispy-safe-delete                  t
                lispy-safe-paste                   t))

(use-package evil-multiedit :demand 
  :commands
  (evil-multiedit-match-all
   evil-multiedit-match-and-next
   evil-multiedit-match-and-prev
   evil-multiedit-match-symbol-and-next
   evil-multiedit-match-symbol-and-prev
   evil-multiedit-toggle-or-restrict-region
   evil-multiedit-next
   evil-multiedit-prev
   evil-multiedit-abort
   evil-multiedit-ex-match)
  :config
  (evil-multiedit-default-keybinds))

(use-package evil-easymotion
  :preface 
  (setq evilem-keys geek/dvorak-home-row) ; Dvorak nonsense
  :config
  (evilem-define (kbd "g SPC h") 'evil-next-visual-line)
  (evilem-define (kbd "g SPC t") 'evil-previous-visual-line))

(use-package evil-snipe
  :config (setq evil-snipe-smart-case t
        evil-snipe-repeat-scope 'visible)
  :init
  (evil-snipe-mode t)
  (evil-snipe-override-mode t))

(use-package evil-surround)

(use-package general
  :config
  (setq general-default-keymaps 'evil-normal-state-map
        general-default-prefix "SPC")
  (general-define-key "SPC" 'counsel-M-x
                      "g"   'counsel-git
                      "f"   'counsel-find-file
                      "hk"  'counsel-descbinds
                      "hz"  'zeal-at-point
                      "hf"  'describe-function
                      "hv"  'describe-variable))

;;
;; `prog-mode'
;;

(defun geek/prog-mode-hook ()
  "Setup for all modes inherited from `prog-mode'."
  (flyspell-prog-mode)
  (company-mode t)
  (column-enforce-mode t)
  (hl-line-mode t)
  (nlinum-mode t)
  (show-paren-mode t)
  (evil-surround-mode t)
  (electric-pair-local-mode t)
  (idle-highlight-mode t)
  (highlight-indent-guides-mode t)
  (flycheck-mode t))

(add-hook 'prog-mode-hook #'geek/prog-mode-hook) 

;;
;; `emacs-lisp-mode'
;;

(defun geek/emacs-lisp-mode-hook ()
  "Setup for `emacs-lisp-mode'."
  (setq-local evil-args-delimiters '(" "))
  (setq dash-enable-fontlock t)
  (eldoc-mode t)
  (evil-lispy-mode t)
  (highlight-quoted-mode t))

(add-hook 'emacs-lisp-mode-hook #'geek/emacs-lisp-mode-hook)

;;
;; `python'
;;

(use-package python
  :init
  (setq python-shell-interpreter "python3")
  (add-hook 'python-mode-hook #'anaconda-mode)
  (add-hook 'python-mode-hook #'anaconda-eldoc-mode))

(use-package company-anaconda :after python
  :config
  (add-to-list 'company-backends 'company-anaconda))

(use-package virtualenv
  :config
  (setq virtualenv-root "~/.venvs"))

(use-package hy)

;;
;; `java'
;;

(use-package eclim
  :config
  (setq eclim-executable (expand-file-name "~/.local/bin/eclim")
        eclimd-executable (expand-file-name "~/.local/bin/eclimd")
        eclimd-autostart t
        eclim-use-yasnippet nil
        help-at-pt-display-when-idle t
        help-at-pt-time-delay 0.1)
  (help-at-pt-set-timer)
  (global-eclim-mode))

;;
;; `clojure'
;;

(use-package clojure
  :config (setq clojure-indent-style :always-indent))

;;
;; `groovy'
;;

(use-package groovy
  :init (setq c-basic-offset 4))

;;
;; `org'
;;

(defun geek/org-mode-hook ()
  "Setup for `org-mode'."
  (when (executable-find "hunspell")
    (flyspell-mode t)))

(add-hook 'org-mode-hook #'geek/org-mode-hook)

(use-package org
  :config
  (setq org-hide-leading-stars t)
  (set-face-attribute 'org-document-title nil :height 1.0))
