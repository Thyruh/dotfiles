;;; forge-ts-mode.el --- Tree-sitter mode for Forge -*- lexical-binding: t; -*-

;; This file intentionally does not use LSP, a package manager, or a formatter.
;; It is just editor syntax support over the Forge Tree-sitter grammar.

(require 'treesit)
(require 'cl-lib)

(defgroup forge-ts nil
  "Tree-sitter support for Forge."
  :group 'languages)

(defcustom forge-ts-mode-indent-offset 4
  "Indentation offset for `forge-ts-mode'."
  :type 'integer
  :safe #'integerp)

(defvar forge-ts-mode--syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?_ "w" table)
    (modify-syntax-entry ?/ ". 124b" table)
    (modify-syntax-entry ?* ". 23" table)
    (modify-syntax-entry ?\n "> b" table)
    table))

(defvar forge-ts-mode--font-lock-settings
  (treesit-font-lock-rules
   :language 'forge
   :feature 'comment
   '((line_comment) @font-lock-comment-face
     (block_comment) @font-lock-comment-face)

   :language 'forge
   :feature 'keyword
   '(["package" "import" "as"
      "fn" "return"
      "if" "else" "for" "break" "continue" "defer"
      "struct" "enum" "match"] @font-lock-keyword-face)

   :language 'forge
   :feature 'modifier
   '(["const" "mut" "public" "private"] @font-lock-keyword-face)

   :language 'forge
   :feature 'type
   '((primitive_type) @font-lock-type-face
     (struct_declaration name: (identifier) @font-lock-type-face)
     (enum_declaration name: (identifier) @font-lock-type-face))

   :language 'forge
   :feature 'function
   '((function_declaration name: (identifier) @font-lock-function-name-face)
     (call_expression function: (identifier) @font-lock-function-name-face)
     (call_expression function: (qualified_identifier) @font-lock-function-name-face)
     (call_expression
      function: (field_expression field: (identifier) @font-lock-function-name-face)))

   :language 'forge
   :feature 'variable
   '((parameter name: (identifier) @font-lock-variable-name-face)
     (variable_declaration name: (identifier) @font-lock-variable-name-face)
     (variable_declaration_no_semicolon name: (identifier) @font-lock-variable-name-face)
     (field_declaration name: (identifier) @font-lock-variable-name-face)
     (field_expression field: (identifier) @font-lock-variable-name-face))

   :language 'forge
   :feature 'literal
   '((integer_literal) @font-lock-number-face
     (char_literal) @font-lock-string-face
     (string_literal) @font-lock-string-face
     (bool_literal) @font-lock-constant-face)))

(defun forge-ts-mode--previous-nonblank-line-opens-block-p ()
  "Return non-nil if the previous nonblank line opens a brace block."
  (save-excursion
    (let ((found nil)
          (opens nil))
      (while (and (not found) (> (line-number-at-pos) 1))
        (forward-line -1)
        (unless (looking-at-p "^[[:space:]]*$")
          (setq found t)
          (setq opens (save-excursion
                        (end-of-line)
                        (skip-chars-backward " \t")
                        (and (> (point) (line-beginning-position))
                             (eq (char-before) ?{))))))
      opens)))

(defun forge-ts-mode--fallback-indent-line ()
  "Small indentation fallback used before the Forge grammar is installed.

It deliberately ignores C-style label indentation, so struct fields like
`x: i32;` stay indented as normal members instead of being yanked to column 0.
The tragedy of C labels is not invited here."
  (interactive)
  (let ((savep (> (current-column) (current-indentation)))
        (offset (- (current-column) (current-indentation)))
        (indent 0))
    (save-excursion
      (beginning-of-line)
      (let ((trimmed (string-trim-left
                      (buffer-substring-no-properties
                       (line-beginning-position)
                       (line-end-position)))))
        (save-excursion
          (if (not (zerop (forward-line -1)))
              (setq indent 0)
            (while (and (not (bobp))
                        (looking-at-p "^[[:space:]]*$"))
              (forward-line -1))
            (setq indent (current-indentation))
            (when (forge-ts-mode--previous-nonblank-line-opens-block-p)
              (setq indent (+ indent forge-ts-mode-indent-offset)))))
        (when (string-prefix-p "}" trimmed)
          (setq indent (max 0 (- indent forge-ts-mode-indent-offset))))))
    (indent-line-to indent)
    (when savep
      (move-to-column (+ indent offset)))))

(defun forge-ts-mode--install-treesit-settings ()
  "Install Tree-sitter font-lock and indentation settings."
  (treesit-parser-create 'forge)
  (setq-local treesit-font-lock-settings forge-ts-mode--font-lock-settings)
  (setq-local treesit-font-lock-feature-list
              '((comment)
                (keyword modifier type)
                (function variable literal)))
  (setq-local treesit-simple-indent-rules
              `((forge
                 ((node-is "}") parent-bol 0)
                 ((node-is "]") parent-bol 0)
                 ((node-is ")") parent-bol 0)
                 ((parent-is "source_file") column-0 0)
                 ((parent-is "struct_declaration") parent-bol ,forge-ts-mode-indent-offset)
                 ((parent-is "enum_declaration") parent-bol ,forge-ts-mode-indent-offset)
                 ((parent-is "block") parent-bol ,forge-ts-mode-indent-offset)
                 ((parent-is "match_expression") parent-bol ,forge-ts-mode-indent-offset)
                 ((parent-is "parameter_list") parent-bol ,forge-ts-mode-indent-offset)
                 ((parent-is "argument_list") parent-bol ,forge-ts-mode-indent-offset))))
  (treesit-major-mode-setup))

;;;###autoload
(define-derived-mode forge-ts-mode prog-mode "Forge"
  "Major mode for Forge using Tree-sitter when available."
  :syntax-table forge-ts-mode--syntax-table
  (setq-local comment-start "//")
  (setq-local comment-end "")
  (setq-local indent-tabs-mode t)
  (setq-local tab-width forge-ts-mode-indent-offset)
  (setq-local indent-line-function #'forge-ts-mode--fallback-indent-line)
  (when (and (treesit-available-p)
             (treesit-ready-p 'forge t))
    (forge-ts-mode--install-treesit-settings)))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.fg\\'" . forge-ts-mode))

(provide 'forge-ts-mode)

;;; forge-ts-mode.el ends here
