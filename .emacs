(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(show-paren-mode 1)
;;; ------------------------------
;;; UI / UX
;;; ------------------------------
(set-face-attribute 'default nil :font "JetBrains Mono ExtraBold-18")
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/gruber-darker")
(load-theme 'gruber-darker t)

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(require 'ansi-color)
(defun rc/colorize-compilation-buffer ()
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region compilation-filter-start (point))))
(add-hook 'compilation-filter-hook #'rc/colorize-compilation-buffer)
(use-package corfu
  :config
  (global-corfu-mode)
  (setq corfu-auto t
        corfu-preselect 'first
        corfu-count 8))
(use-package tree-sitter :defer t)
(use-package tree-sitter-langs :after tree-sitter :defer t)
(when (require 'tree-sitter nil 'noerror)
  (global-tree-sitter-mode 1)
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(require 'dired-x)
(setq dired-listing-switches "-alFhG --group-directories-first"
      dired-dwim-target t
      dired-mouse-drag-files t)

(add-hook 'dired-mode-hook #'dired-omit-mode)
(setq dired-omit-files (concat dired-omit-files "\\|^\\..+$"))

(use-package dired
  :ensure nil ;; built-in
  :commands (dired dired-jump)
  :config
  ;; Let dired use the same buffer when opening dirs
  (setq dired-kill-when-opening-new-dired-buffer t))
(global-set-key (kbd "C-c C-c") 'compile)
(setq compile-command " "
      compilation-read-command t)
(setq auto-save-default nil
      make-backup-files nil
      create-lockfiles nil)

;;; ------------------------------
;;; Final touches
;;; ------------------------------
(setq lsp-auto-guess-root t)


(setq custom-file (expand-file-name "~/.emacs-custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(setq lsp-auto-guess-root t)

(setq-default cursor-type 'box
              cursor-in-non-selected-windows 'box)
(blink-cursor-mode 1)
(setq blink-cursor-interval 0.5)

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)
(setq-default truncate-lines t)

(show-paren-mode 1)
(setq show-paren-delay 0)
(global-hl-line-mode 1)

(setq-default tab-width 2
              indent-tabs-mode nil)

(setq inhibit-startup-screen t
      initial-scratch-message nil
      initial-buffer-choice t
      use-dialog-box nil)

;;; ------------------------------
;;; Whitespace handling
;;; ------------------------------
(require 'whitespace)
(setq whitespace-style '(face tabs spaces trailing))
(global-whitespace-mode 1)
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defun rc/set-up-whitespace-handling ()
  "Enable basic whitespace handling without trailing $ markers."
  (whitespace-mode 1)
  (add-hook 'before-save-hook #'delete-trailing-whitespace nil t))
(add-hook 'prog-mode-hook #'rc/set-up-whitespace-handling)
(add-hook 'text-mode-hook #'rc/set-up-whitespace-handling)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu"   . "https://elpa.gnu.org/packages/"))
      package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

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

(global-set-key (kbd "C-x C-r") 'query-replace)
(global-set-key (kbd "C-x C-w") 'other-window)
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

;; Explicitly disable Ivy/Counsel to avoid conflicts with icomplete
(when (fboundp 'ivy-mode)    (ivy-mode -1))
(when (fboundp 'counsel-mode)(counsel-mode -1))

;;; ------------------------------
;;; Consult (Telescope-like pickers)
;;; ------------------------------
(use-package consult
  :bind (("C-,"   . consult-buffer)     ;; buffers + recent files
         ("C-/"   . consult-line)       ;; search in current buffer
         ("M-y"   . consult-yank-pop)   ;; fuzzy kill-ring
         ("C-x r b" . consult-bookmark)
         ("C-x C-r" . consult-recent-file))
  :config
  ;; Fix consult-project root detection for VC repos
  (setq consult-project-function
        (lambda (_prompt) (when (fboundp 'vc-root-dir) (vc-root-dir))))
  (setq consult-project-root-function
        (lambda () (when (fboundp 'vc-root-dir) (vc-root-dir))))

  ;; Project ripgrep helper
  (defun thy/consult-ripgrep-project ()
    "Run consult-ripgrep from the project root if available, else default dir."
    (interactive)
    (let ((default-directory (or (funcall consult-project-root-function)
                                 default-directory)))
      (consult-ripgrep default-directory))))
(global-set-key (kbd "C-.") #'thy/consult-ripgrep-project)
;;; ------------------------------
;;; Core editing helpers
;;; ------------------------------
(setq-default scroll-margin 5
              scroll-conservatively 9999
              scroll-step 1)

(toggle-word-wrap 0)
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
