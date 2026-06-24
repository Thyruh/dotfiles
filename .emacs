;;; ~/.emacs --- Thyruh's organized Emacs config -*- lexical-binding: t; -*-

;;; =========================
;;; User binaries
;;; =========================

(defconst thyruh-user-bin-dir (expand-file-name "~/bin"))

(when (file-directory-p thyruh-user-bin-dir)
  (add-to-list 'exec-path thyruh-user-bin-dir)
  (setenv "PATH"
          (concat thyruh-user-bin-dir
                  path-separator
                  (or (getenv "PATH") ""))))

;;; =========================
;;; Safe dependency tracing (optional debug)
;;; =========================
;; (trace-function-background 'set-face-attribute)

;;; =========================
;;; Package setup (HARDENED)
;;; =========================

(require 'package)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/"))
      package-enable-at-startup nil)

(package-initialize)

(defvar rc/package-contents-refreshed nil)

(defun rc/package-refresh-contents-once ()
  (unless rc/package-contents-refreshed
    (setq rc/package-contents-refreshed t)
    (package-refresh-contents)))

(defun rc/require-one-package (package)
  (unless (package-installed-p package)
    (rc/package-refresh-contents-once)
    (ignore-errors (package-install package))))

(defun rc/require (&rest packages)
  (dolist (package packages)
    (rc/require-one-package package)))

(rc/require 'use-package)
(require 'use-package)
(setq use-package-always-ensure t)

(rc/require 'dash 'dash-functional)
(require 'dash)
(ignore-errors (require 'dash-functional))

;;; =========================
;;; Theme loader helper (FIXED)
;;; =========================

;;; ensure theme path exists
(add-to-list 'custom-theme-load-path
             "~/.emacs.d/themes/cinder-atlas-theme/")

(defun thy/load-theme-safe ()
  (ignore-errors
    (load-theme 'cinder-atlas t)))


;;; =========================
;;; UI / UX
;;; =========================

;; FONT FIX (daemon-safe + frame-safe)
(set-face-attribute 'default nil :font "JetBrains Mono ExtraBold-20")

(defun thy/apply-font-to-frame (frame)
  (when frame
    (with-selected-frame frame
      (ignore-errors
        (set-face-attribute 'default frame :font thy/font)))))

(add-hook 'after-make-frame-functions #'thy/apply-font-to-frame)
(add-hook 'emacs-startup-hook
          (lambda ()
            (thy/apply-font-to-frame (selected-frame))))

;; IMPORTANT: do NOT use initial-buffer-choice t (breaks daemon UX)
(setq inhibit-startup-screen t
      initial-scratch-message nil
      use-dialog-box nil)

(setq initial-major-mode 'text-mode)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)

(set-fringe-mode '(2 . 0))

(setq-default cursor-type 'box
              cursor-in-non-selected-windows 'box)

(blink-cursor-mode 1)
(setq blink-cursor-interval 0.5)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 0)

(setq-default truncate-lines t)
(toggle-word-wrap 0)

(show-paren-mode 1)
(setq show-paren-delay 0)
(global-hl-line-mode 1)

(setq-default scroll-margin 5
              scroll-conservatively 9999
              scroll-step 1)

(load "~/.emacs.d/personal/common.el")

;;; =========================
;;; Compilation coloring
;;; =========================

(require 'ansi-color)

(defun rc/colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region compilation-filter-start (point))))

(add-hook 'compilation-filter-hook #'rc/colorize-compilation-buffer)

;;; =========================
;;; Treesit / C3
;;; =========================

(require 'treesit)

(add-to-list 'treesit-language-source-alist
             '(c3 "https://github.com/c3lang/tree-sitter-c3"))

(add-to-list 'load-path "~/.emacs.d/lisp/c3-ts-mode")

(ignore-errors (require 'c3-ts-mode))

(setq c3-ts-mode-indent-offset 4
      treesit-font-lock-level 4)

(add-to-list 'auto-mode-alist '("\\.c3[it]?\\'" . c3-ts-mode))

;;; =========================
;;; Dired
;;; =========================

(require 'dired-x)

(setq dired-listing-switches "-alFhG --group-directories-first"
      dired-dwim-target t
      dired-mouse-drag-files t)

(add-hook 'dired-mode-hook #'dired-omit-mode)
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :config
  (setq dired-kill-when-opening-new-dired-buffer t))

(global-set-key (kbd "C-x d") #'dired)

;;; =========================
;;; Compilation keys
;;; =========================

(global-set-key (kbd "C-c c") #'compile)
(global-set-key (kbd "C-c r") #'recompile)

(setq compile-command ""
      compilation-read-command t)

;;; =========================
;;; Files / backups
;;; =========================

(setq auto-save-default nil
      auto-save-list-file-prefix nil
      make-backup-files nil
      create-lockfiles nil)

;;; =========================
;;; Tabs / indentation
;;; =========================

(setq-default tab-width 4
              indent-tabs-mode t)

(defun thyruh-fundamental-tabs ()
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  (local-set-key (kbd "TAB") #'insert-tab))

(add-hook 'fundamental-mode-hook #'thyruh-fundamental-tabs)

(setq-default c-basic-offset 4
              c-ts-mode-indent-offset 4
              c++-ts-mode-indent-offset 4)

;;; =========================
;;; Whitespace tools
;;; =========================

(defface thy/leading-space-face
  '((t (:background "firebrick" :foreground "white")))
  "Face for leading spaces in code buffers.")

(defface thy/trailing-whitespace-face
  '((t (:background "red1" :foreground "white")))
  "Face for trailing whitespace in code buffers.")

(defun thy/highlight-extra-whitespace ()
  (whitespace-mode -1)
  (setq-local whitespace-action nil)
  (font-lock-add-keywords
   nil
   '(("^ +" 0 'thy/leading-space-face prepend)
     ("[ \t]+$" 0 'thy/trailing-whitespace-face prepend))
   'append)
  (font-lock-flush)
  (font-lock-ensure))

(add-hook 'forge-ts-mode-hook #'thy/highlight-extra-whitespace)
(add-hook 'c++-mode-hook #'thy/highlight-extra-whitespace)
(add-hook 'c-mode-hook #'thy/highlight-extra-whitespace)

;;; =========================
;;; Editing packages
;;; =========================

(use-package multiple-cursors
  :bind (("C->" . mc/mark-next-like-this)
         ("C-<" . mc/mark-previous-like-this)
         ("C-c C-<" . mc/mark-all-like-this)))

(rc/require 'paredit 'move-text)

(global-set-key (kbd "M-p") #'move-text-up)
(global-set-key (kbd "M-n") #'move-text-down)

(global-set-key (kbd "C-x C-r") #'query-replace)
(global-set-key (kbd "C-x C-w") #'other-window)
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

;;; =========================
;;; Completion (icomplete)
;;; =========================

(icomplete-mode 1)
(fido-mode 1)
(fido-vertical-mode -1)

(setq icomplete-compute-delay 0
      icomplete-hide-common-prefix nil
      icomplete-show-matches-on-no-input t
      icomplete-separator "  |  ")

(with-eval-after-load 'icomplete
  (define-key icomplete-minibuffer-map (kbd "C-n") #'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "C-p") #'icomplete-backward-completions))

(use-package marginalia
  :init (marginalia-mode 1))

;;; =========================
;;; Company
;;; =========================

(use-package company
  :hook ((prog-mode text-mode) . company-mode)
  :config
  (setq company-idle-delay 0.20
        company-minimum-prefix-length 2
        company-require-match nil
        company-selection-wrap-around t
        company-backends
        '((company-etags company-dabbrev-code company-keywords)
          company-dabbrev
          company-files)))

;;; =========================
;;; Consult (FIXED override behavior)
;;; =========================

(use-package consult
  :bind (("C-," . consult-buffer)
		 ("C-." . consult-ripgrep)
         ("C-/" . consult-line)
         ("M-y" . consult-yank-pop)
         ("C-x r b" . consult-bookmark)
         ("C-x C-r" . consult-recent-file)))

;;; =========================
;;; Forge treesit mode
;;; =========================

(add-to-list 'load-path
             (expand-file-name "~/Programming/personal/forge-ref/tools/editor/emacs"))

(add-to-list 'treesit-extra-load-path
             (expand-file-name "~/.emacs.d/tree-sitter"))

(ignore-errors (require 'forge-ts-mode))

(add-to-list 'auto-mode-alist
             '("\\.fg\\'" . forge-ts-mode))

;;; =========================
;;; MIT abbrev
;;; =========================

(define-abbrev global-abbrev-table
  "MIT"
  (format
   "MIT License

Copyright (c) %s Yuzef Shumovich <shumovichyuzef@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the \"Software\"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE."
   (format-time-string "%Y")))

(add-hook 'emacs-startup-hook #'thy/load-theme-safe)

;;; =========================
;;; Custom file
;;; =========================

(setq custom-file (expand-file-name "~/.emacs-custom-vars.el"))
(load custom-file 'noerror 'nomessage)

;;; =========================
;;; custom-set (kept)
;;; =========================

(custom-set-variables
 '(package-selected-packages '(consult sexy marginalia smartparens)))

(custom-set-faces)

;;; ==================================================
;;; Unsetting annoying quality not-life binds
;;; ==================================================

(keymap-global-unset "C-x C-c")
(keymap-global-unset "C-x f")

;;; END
(put 'narrow-to-region 'disabled nil)
