;;; cinder-atlas-theme.el --- Cinder Atlas theme -*- lexical-binding: t; -*-


;; Author: Thyruh
;; Version: 0.1.2
;; Package-Requires: ((emacs "27.1"))
;; SPDX-License-Identifier: MIT
;; URL: https://github.com/Thyruh/cinder-atlas-theme
;;
;; This file is distributed under the MIT License.


;;; MIT License

;; Copyright (c) 2026 Yuzef Shumovich <shumovichyuzef@gmail.com>

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.


(deftheme cinder-atlas "Cinder Atlas color theme")

(let ((background		"#0e070d")
      (text				"#d1b897")
	  (selection		"#23404d")

      (comments			"#62788F")
      (punctuation		"#808080")

      (keywords			"#ffffff")
      (variables		"#c1d1e3")
      (functions		"#ffffff")
      (methods			"#c1d1e3")
      (strings			"#73c936")
      (constants		"#808080")
      (macros			"#8cde94")

      (builtin			"#ffffff")

      (white			"#ffffff")

      (error			"#ff0000")
      (warning			"#ffaa00")

      (highlight-line	"#0b3335"))

  (custom-theme-set-faces
   'cinder-atlas

   ;; Core UI
   `(default ((t (:foreground ,text :background ,background))))
   `(cursor  ((t (:background ,white))))
   `(region  ((t (:background ,selection))))
   `(fringe  ((t (:background ,background :foreground ,white))))
   `(highlight ((t (:background ,selection))))

   ;; font-lock
   `(font-lock-keyword-face           ((t (:foreground ,keywords))))
   `(font-lock-type-face              ((t (:foreground ,punctuation))))
   `(font-lock-constant-face          ((t (:foreground ,constants))))
   `(font-lock-variable-name-face     ((t (:foreground ,variables))))
   `(font-lock-builtin-face           ((t (:foreground ,builtin))))
   `(font-lock-string-face            ((t (:foreground ,strings))))
   `(font-lock-comment-face           ((t (:foreground ,comments))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,comments))))
   `(font-lock-doc-face               ((t (:foreground ,comments))))
   `(font-lock-function-name-face     ((t (:foreground ,functions))))
   `(font-lock-preprocessor-face      ((t (:foreground ,macros))))
   `(font-lock-warning-face           ((t (:foreground ,warning))))

   ;; line
   `(hl-line ((t (:background ,highlight-line))))
   `(line-number ((t (:foreground ,comments :background ,background))))
   `(line-number-current-line ((t (:foreground ,white :background ,background))))

   ;; whitespace
   `(trailing-whitespace ((t (:background ,warning))))
   `(whitespace-trailing ((t (:background ,warning))))

   ;; compilation
   `(compilation-info    ((t (:foreground ,macros))))
   `(compilation-warning ((t (:foreground ,warning :weight bold))))
   `(compilation-error   ((t (:foreground ,error :weight bold))))


   ;; (v0.1.1) Fixed: https://emacs.stackexchange.com/questions/85836/i-need-help-extending-my-theme-mode-line-inactive-selection-framing
   ;; thanks to NickD.
   
   ;; mode-line
   `(mode-line
	 ((t (:background ,text
					  :foreground ,background
					  :box (:line-width 1 :color "#bfbfbf")))))
                         ;; @Unstable:  ^ Changing this to 0 makes all the colours blow up for some reason.
                         ;;               @TRY: Remove the box option completely from here.

   `(mode-line-inactive
	 ((t (:background ,background
					  :foreground ,text
					  :box (:line-width 1 :color "#bfbfbf")))))


   ;; misc
   `(error ((t (:foreground ,error))))
   `(which-func ((t (:weight bold))))))


;;;###autoload
(when (and (boundp 'custom-theme-load-path) load-file-name)
  (add-to-list 'custom-theme-load-path
               (file-name-directory load-file-name)))

(provide-theme 'cinder-atlas)
(provide 'cinder-atlas-theme)

;;; cinder-atlas-theme.el ends here
