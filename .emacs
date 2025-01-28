;;; package --- summary
;;; Commentary:
;;; Reminder: C-numbers is a bindable thing
;;; Code:

(load "~/.emacs-custom" 'noerror 'nomessage)

;; Initialize package and use-package if not installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Install and configure Go mode
(use-package go-mode
  :ensure t
  :hook ((go-mode . lsp-deferred)
         (before-save . lsp-format-buffer)
         (before-save . lsp-organize-imports)))

;;(use-package copilot
;;  :ensure t
;;  :config
;;  (add-hook 'prog-mode-hook 'copilot-mode))

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")))
(package-initialize)

;; Install and configure lsp-mode, lsp-ui, company, flycheck
(use-package lsp-mode
  :ensure t
  :hook ((c-mode c++-mode), lsp, go-mode)
  :commands lsp)

(lsp 1)
(column-number-mode 1)

(require 'bf-mode)

(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
(smartparens-global-mode t))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode)

;; Enable symbol highlighting for all LSP-enabled languages
(setq lsp-enable-symbol-highlighting t)

(use-package company
  :ensure t
  :config
  (add-hook 'after-init-hook 'global-company-mode))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(add-hook 'haskell-mode-hook 'flycheck-mode)

(require 'quelpa)
(require 'use-package)
(require 'quelpa-use-package)

;;(use-package copilot
;;  :quelpa (copilot :fetcher github
;;                   :repo "copilot-emacs/copilot.el"
;;                   :branch "main"
;;                 :files ("*.el")))


;; Copilot keybindings
;;(define-key copilot-mode-map (kbd "C-<tab>") 'copilot-complete)
;;(define-key copilot-mode-map (kbd "C-<return>") 'copilot-accept-completion)
;;(define-key copilot-mode-map (kbd "C-<shift>") 'copilot-accept-completion-by-word)
;;(define-key copilot-mode-map (kbd "C-<backspace>") 'copilot-cancel-completion)

;; Enable global auto revert mode
(global-auto-revert-mode t)

;; Don't pop up UI dialogs
(setq use-dialog-box nil)

;;Revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

;; Configure eglot (remove if using lsp-mode instead)
(use-package eglot
  :ensure t
  :hook ((c-mode c++-mode) . eglot))

(setq history-length 25)
(savehist-mode 1)

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)

;; Set tab width to 4 spaces globally
(setq-default tab-width 3)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

(setq show-paren-delay 0) ;; No delay
(show-paren-mode 1)

;; Escape key binding
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Enable relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Ivy setup
(setq make-backup-files nil)
(ivy-mode 1)

;; Enable counsel and swiper
(counsel-mode 1)
(global-set-key (kbd "C-,") 'counsel-switch-buffer)

;; Disable arrow keys globally
(global-set-key [left] 'ignore)
(global-set-key [right] 'ignore)
(global-set-key [down] 'ignore)
(global-set-key [up] 'ignore)

(global-font-lock-mode 1)

;; Theme setup
(load-theme 'cyberpunk-thyruh t)
(set-frame-parameter (selected-frame) 'alpha '(85 . 85))
(add-to-list 'default-frame-alist '(alpha . (85 . 85)))
             
;; A lambda function to open shell buffer
(global-set-key (kbd "C-h l") 'shell)

;; A function to delete the contents of the brackets at point
(defun delete-brackets ()
  "Delete the contents of the brackets, leaving the brackets themselves."
  (interactive)
  (save-excursion
    (let* ((syntax (syntax-ppss)) ;; Parse the current syntax state
           (start (nth 1 syntax)) ;; Get the position of the opening bracket
           (end (when start (scan-sexps start 1)))) ;; Find the position of the closing bracket
      (if (and start end)
          (progn
            (delete-region (1+ start) (1- end))
            (message "Deleted contents inside brackets."))
        (message "Not inside a bracketed region!")))))
(global-set-key (kbd "C-x w") 'delete-brackets)


;; Keybinding for selecting current word
(defun select-word ()
  "Select the current word."
  (interactive)
  (skip-syntax-backward "w_")
  (set-mark (point))
  (skip-syntax-forward "w_"))
(global-set-key (kbd "C-c w") 'select-word)

(defun select-and-delete-word ()
  "Select the current word and delete it."
  (interactive)
  (select-word)
  (delete-region (region-beginning) (region-end)))
(global-set-key (kbd "C-w") 'select-and-delete-word)

;; hotkey for inbuilt compile function
(global-set-key (kbd "C-c c") 'compile)

(defun compile-file ()
  "Compile the current file depending on its extension."
  (interactive)
  (let ((file-name (buffer-file-name))
        (output-file))
    (cond
     ;; Compile C++ files
     ((string-match "\\.cpp\\'" file-name)
      (setq output-file (concat "~/Architect/C++/Bins/" (file-name-sans-extension (file-name-nondirectory file-name))))
      (compile (concat "g++ -o " output-file " " file-name)))
     
     ;; Compile Go files
     ((string-match "\\.go\\'" file-name)
      (setq output-file (concat "~/Architect/Go/Bins/" (file-name-sans-extension (file-name-nondirectory file-name))))
      (compile (concat "go build -o " output-file " " file-name)))
     
     ;; Compile Haskell files
     ((string-match "\\.hs\\'" file-name)
      (setq output-file (concat "~/Architect/Haskell/Bins/" (file-name-sans-extension (file-name-nondirectory file-name))))
      ;; Haskell needs to use ghc or ghc --make to compile and generate the output
      (compile (concat "ghc --make " file-name " -o " output-file)))
     
     ;; Error for unsupported file types
     (t (error "Unsupported file type")))))

(global-set-key (kbd "C-c C-c") 'compile-file)


;; Hotkeys for file navigation
(defvar my-init-file "~/.emacs")
(global-set-key (kbd "C-c f") (lambda () (interactive) (message "Switching to the emacs config file...")          (find-file my-init-file)))
(global-set-key (kbd "C-c r") (lambda () (interactive) (message "Switching to the fish config file...")           (find-file "~/.bashrc")))
(global-set-key (kbd "C-c i") (lambda () (interactive) (message "Switching to the i3 config file...")             (find-file "~/.config/i3/config")))
(global-set-key (kbd "C-c v") (lambda () (interactive) (message "Switching to the main programming directory...") (find-file "~/Architect")))

;; Keybinding for moving lines up and down
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)
(global-set-key (kbd "C-q") 'back-to-indentation)


(defun del-whole-line (&optional arg)
  "Delete the current line.
With prefix ARG, delete that many lines starting from the current line.
If ARG is negative, delete backward. Also delete the preceding newline.
If ARG is zero, delete the current line but exclude the trailing newline."
  (interactive "p")
  (or arg (setq arg 1))
  (if (and (> arg 0) (eobp) (save-excursion (forward-visible-line 0) (eobp)))
      (signal 'end-of-buffer nil))
  (if (and (< arg 0) (bobp) (save-excursion (end-of-visible-line) (bobp)))
      (signal 'beginning-of-buffer nil))
  (cond ((zerop arg)
         ;; Delete the current line without its trailing newline
         (save-excursion
           (delete-region (point) (progn (forward-visible-line 0) (point))))
         (delete-region (point) (progn (end-of-visible-line) (point))))
        ((< arg 0)
         ;; Delete lines backward
         (save-excursion
           (delete-region (point) (progn (end-of-visible-line) (point))))
         (delete-region (point)
                        (progn (forward-visible-line (1+ arg))
                               (unless (bobp) (backward-char))
                               (point))))
        (t
         ;; Delete lines forward
         (save-excursion
           (delete-region (point) (progn (forward-visible-line 0) (point))))
         (delete-region (point)
                        (progn (forward-visible-line arg) (point))))))

(global-set-key (kbd "C-u") 'del-whole-line)

;; Keybinding for selecting whole line
(defun select-current-line ()
  "SELECT the whole line."
  (interactive)
  (move-beginning-of-line 1)
  (set-mark (point))
  (move-end-of-line 1))
(global-set-key (kbd "C-c l") 'select-current-line)

;; Functions for jumping around in the buffer
(defun jump-n-lines (n)
  "Jump forward by N lines if N is positive, or backward by N lines"
  (interactive "nNumber of lines to jump: ")
  (forward-line n))
(global-set-key (kbd "M-g g") 'jump-n-lines)

;; Duplication of current line
(defun duplicate-current-line ()
  "Duplicate the current line."
  (interactive)
  (beginning-of-line)
  (kill-ring-save (point) (line-end-position))
  (end-of-line)
  (newline)
  (yank))
(global-set-key (kbd "C-c d") 'duplicate-current-line)

;; Evaluate the buffer
(global-set-key (kbd "C-j")
  (lambda ()
    (interactive)
    (eval-buffer)
    (message "Buffer evaluated!")))

(global-set-key (kbd "M-w") 'copy-region-as-kill)

(setq lsp-enable-on-type-formatting nil)
(setq lsp-format-buffer nil)
;;; .emacs ends here
(put 'lsp-copilot-check-status 'disabled t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("7118cb43b6fd2eefe15dc4270ce2eb74247704c3d7900fe44abb19f27f62e148" "c7341ec85ca2e03095e1b59067ac7a31831b0aa6b0472211253c15ca08137a19" "482abedce6ba11a42523c5cb2970091bb30d13466dab74356fd55e6312fb4cd4" "ec1d6aa3be417bbbc88552c3eadeb6788d25eae2ced74817f9b394e0bf8aa2eb" "f4d1b183465f2d29b7a2e9dbe87ccc20598e79738e5d29fc52ec8fb8c576fcfd" "e13beeb34b932f309fb2c360a04a460821ca99fe58f69e65557d6c1b10ba18c7" default))
 '(inhibit-startup-screen t)
 '(package-selected-packages
   '(treemacs peep-dired copilot smartparens company quelpa-use-package flycheck use-package-hydra move-text lsp-mode lsp-ui eglot doom-themes counsel ivy-explorer ivy gruber-darker-theme))
 '(warning-suppress-log-types
   '((use-package)
     (use-package)
     ((copilot copilot-no-mode-indent))))
 '(warning-suppress-types '((use-package) ((copilot copilot-no-mode-indent)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
