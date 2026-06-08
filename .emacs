;;; ~/.emacs --- Thyruh's organized Emacs config -*- lexical-binding: t; -*-

;;; User binaries
(defconst thyruh-user-bin-dir (expand-file-name "~/bin"))

(when (file-directory-p thyruh-user-bin-dir)
  (add-to-list 'exec-path thyruh-user-bin-dir)
  (setenv "PATH"
          (concat thyruh-user-bin-dir
                  path-separator
                  (or (getenv "PATH") ""))))

;;; Package setup
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
    (package-install package)))

(defun rc/require (&rest packages)
  (dolist (package packages)
    (rc/require-one-package package)))

(rc/require 'use-package)
(require 'use-package)
(setq use-package-always-ensure t)

(rc/require 'dash 'dash-functional)
(require 'dash)
(require 'dash-functional)

(defun rc/require-theme (theme)
  (let ((theme-package (->> theme
                            (symbol-name)
                            (funcall (-flip #'concat) "-theme")
                            (intern))))
    (rc/require theme-package)
    (load-theme theme t)))

;;; UI / UX
(set-face-attribute 'default nil :font "JetBrains Mono ExtraBold-18")

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/gruber-darker")
(load-theme 'gruber-darker t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode 1)

(setq inhibit-startup-screen t
      initial-scratch-message nil
      initial-buffer-choice t
      use-dialog-box nil)

(setq-default cursor-type 'box
              cursor-in-non-selected-windows 'box)

(blink-cursor-mode 1)
(setq blink-cursor-interval 0.5)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(setq-default truncate-lines t)
(toggle-word-wrap 0)

(show-paren-mode 1)
(setq show-paren-delay 0)
(global-hl-line-mode 1)

(setq-default scroll-margin 5
              scroll-conservatively 9999
              scroll-step 1)

;;; Compilation output coloring
(require 'ansi-color)

(defun rc/colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region compilation-filter-start (point))))

(add-hook 'compilation-filter-hook #'rc/colorize-compilation-buffer)

;;; Tree-sitter
(use-package tree-sitter
  :defer t)

(use-package tree-sitter-langs
  :after tree-sitter
  :defer t)

(when (require 'tree-sitter nil 'noerror)
  (global-tree-sitter-mode 1)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))


(require 'treesit)

(add-to-list 'treesit-language-source-alist
             '(c3 "https://github.com/c3lang/tree-sitter-c3"))

(add-to-list 'load-path "~/.emacs.d/lisp/c3-ts-mode")
(require 'treesit)

(add-to-list 'treesit-language-source-alist
             '(c3 "https://github.com/c3lang/tree-sitter-c3"))
(require 'c3-ts-mode)

(setq c3-ts-mode-indent-offset 4
      treesit-font-lock-level 4)

(add-to-list 'auto-mode-alist '("\\.c3[it]?\\'" . c3-ts-mode))

;;; Dired
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
  ;; Let Dired use the same buffer when opening directories.
  (setq dired-kill-when-opening-new-dired-buffer t))

(global-set-key (kbd "C-x d") #'dired)

;;; Compilation keys
(global-set-key (kbd "C-c c") #'compile)
(global-set-key (kbd "C-c r") #'recompile)

(setq compile-command ""
      compilation-read-command t)

;;; Files / backups / autosaves
(setq auto-save-default nil
      auto-save-list-file-prefix nil
      make-backup-files nil
      create-lockfiles nil)

;;; LSP
(setq lsp-auto-guess-root t)

;;; Tabs / indentation
(setq-default tab-width 4
              indent-tabs-mode t)

(defun thyruh-fundamental-tabs ()
  (setq tab-width 4)
  (setq indent-tabs-mode t)
  (local-set-key (kbd "TAB") #'insert-tab))

(add-hook 'fundamental-mode-hook #'thyruh-fundamental-tabs)

;; C / C++ classic modes.
(setq-default c-basic-offset 4)

;; Tree-sitter C / C++ modes.
(setq-default c-ts-mode-indent-offset 4)
(setq-default c++-ts-mode-indent-offset 4)

;;; ------------------------------
;;; Forge: highlight extra whitespace
;;; ------------------------------

(require 'whitespace)

(defun thy/forge-highlight-extra-whitespace ()
  "Highlight suspicious whitespace in Forge buffers."
  (setq-local whitespace-style
              '(face
                trailing
                tabs
                space-before-tab
                empty))

  ;; Buffer-local face overrides, so this does not poison every mode.
  (face-remap-add-relative 'whitespace-trailing
                           '(:background "red1" :foreground "white"))
  (face-remap-add-relative 'whitespace-tab
                           '(:background "firebrick"))
  (face-remap-add-relative 'whitespace-space-before-tab
                           '(:background "red1" :foreground "white"))
  (face-remap-add-relative 'whitespace-empty
                           '(:background "red1" :foreground "white"))

  (whitespace-mode 1))

(add-hook 'forge-ts-mode-hook #'thy/forge-highlight-extra-whitespace)
(add-hook 'forgelang-mode-hook #'thy/forge-highlight-extra-whitespace)
;;; Editing packages
(rc/require 'paredit 'move-text)

(global-set-key (kbd "M-p") #'move-text-up)
(global-set-key (kbd "M-n") #'move-text-down)

;;; Global keys
(global-set-key (kbd "C-x C-r") #'query-replace)
(global-set-key (kbd "C-x C-w") #'other-window)
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

;;; ------------------------------
;;; Minibuffer completion style (Tsoding-like)
;;; ------------------------------
;; Pure icomplete/fido (horizontal) + Marginalia annotations.
(icomplete-mode 1)
(fido-mode 1)
(fido-vertical-mode -1) ;; ensure horizontal UI, not vertical

(setq icomplete-compute-delay 0
      icomplete-hide-common-prefix nil
      icomplete-show-matches-on-no-input t
      icomplete-separator "  |  ")

;; Make C-n / C-p move through candidates (not history)
(with-eval-after-load 'icomplete
  (define-key icomplete-minibuffer-map (kbd "C-n") #'icomplete-forward-completions)
  (define-key icomplete-minibuffer-map (kbd "C-p") #'icomplete-backward-completions))

;; Nice annotations in minibuffer candidates
(use-package marginalia
  :init (marginalia-mode 1))

;; Explicitly disable Ivy/Counsel to avoid conflicts with icomplete
(when (fboundp 'ivy-mode)    (ivy-mode -1))
(when (fboundp 'counsel-mode)(counsel-mode -1))

;;; ------------------------------
;;; In-buffer completion: Company
;;; Auto-popup, no LSP
;;; Sources: TAGS + open buffers + keywords + files
;;; ------------------------------

(use-package company
  :hook ((prog-mode text-mode) . company-mode)
  :config
  (setq company-idle-delay 0.20
        company-minimum-prefix-length 2
        company-tooltip-align-annotations t
        company-require-match nil
        company-selection-wrap-around t

        ;; Auto-trigger while typing normal characters.
        company-begin-commands '(self-insert-command)

        ;; No LSP. No semantic server. Just old-school sources.
        company-backends
        '((company-etags company-dabbrev-code company-keywords)
          company-dabbrev
          company-files)

        ;; Preserve original casing. Emacs defaults love vandalism.
        company-dabbrev-code-everywhere t
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case nil)

  ;; Keep a manual trigger too.
  (global-set-key (kbd "C-c SPC") #'company-complete)
  (global-set-key (kbd "C-c TAB") #'company-complete)

  ;; Popup navigation.
  (define-key company-active-map (kbd "M-n") #'company-select-next)
  (define-key company-active-map (kbd "M-p") #'company-select-previous)
  (define-key company-active-map (kbd "TAB") #'company-complete-selection)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection)
  (define-key company-active-map (kbd "RET") #'company-complete-selection)
  (define-key company-active-map (kbd "<return>") #'company-complete-selection))

;;; Consult, preserved
(use-package consult
  :bind (("C-,"     . consult-buffer)       ;; buffers + recent files
         ("C-/"     . consult-line)         ;; search in current buffer
         ("M-y"     . consult-yank-pop)     ;; fuzzy kill-ring
         ("C-x r b" . consult-bookmark)
         ("C-x C-r" . consult-recent-file))
  :config
  ;; Fix consult-project root detection for VC repos.
  (setq consult-project-function
        (lambda (_prompt)
          (when (fboundp 'vc-root-dir)
            (vc-root-dir))))

  (setq consult-project-root-function
        (lambda ()
          (when (fboundp 'vc-root-dir)
            (vc-root-dir))))

  ;; Project ripgrep helper.
  (defun thy/consult-ripgrep-project ()
    "Run consult-ripgrep from the project root if available, else default dir."
    (interactive)
    (let ((default-directory (or (funcall consult-project-root-function)
                                 default-directory)))
      (consult-ripgrep default-directory))))

(global-set-key (kbd "C-.") #'thy/consult-ripgrep-project)

;;; Forge language modes
(add-to-list 'load-path
             (expand-file-name "~/Programming/personal/forge/tools/editor/emacs"))

(add-to-list 'treesit-extra-load-path
             (expand-file-name "~/.emacs.d/tree-sitter"))

(require 'forge-emacs)

;;; Custom file
(setq custom-file (expand-file-name "~/.emacs-custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(consult gruber-darker-theme marginalia smartparens)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; fixed-emacs.el ends here
