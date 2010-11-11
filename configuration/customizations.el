;;; my customizations for emacs

(setq user-full-name "Vedang Manerikar"
      user-mail-address "vedang.manerikar@gmail.com")

(setq delete-selection-mode t
      debug-on-error t)

(setq bookmark-default-file "~/.emacs.d/bookmarks.bmk"
      bookmark-save-flag 1) ;; save my bookmarks as soon as I create them

(setq visible-bell t
      echo-keystrokes 0.1
      inhibit-startup-message t
      transient-mark-mode t
      color-theme-is-global t
      require-final-newline t
      ediff-window-setup-function 'ediff-setup-windows-plain
      save-place-file (concat dotfiles-dir "places"))

(add-to-list 'safe-local-variable-values '(lexical-binding . t))
(add-to-list 'safe-local-variable-values '(whitespace-line-column . 80))

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "conkeror")

(setq-default ispell-program-name "aspell")

;; Completion ignores filenames ending in any string in this list.
(setq completion-ignored-extensions
   '(".o" ".elc" "~" ".bin" ".class" ".exe" ".ps" ".abs" ".mx" ".~jv" ".rbc"))

;; Always reuse a buffer if it already exists.
;; Useful when dealing with REPLs
(setq display-buffer-reuse-frames t)

;; delete trailing whitespace in files
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(defvar programming-major-modes
  '(js2-mode c-mode c++-mode conf-mode clojure-mode)
  "List of programming modes")

(defun vedang/prog-mode-settings ()
  "special settings for programming modes."
  (when (memq major-mode programming-major-modes)
    ;; No stray edits.Toggle with (C-x C-q) if I want to make an edit
    (toggle-read-only 1)
    ;; Flyspell mode for comments and strings
    (flyspell-prog-mode)))

(add-hook 'find-file-hook 'vedang/prog-mode-settings)

;; Indentation hook for C/C++ mode
;; As defined in Documentation/CodingStyle
(defun vedang/linux-c-indent ()
  "adjusted defaults for C/C++ mode use with the Linux kernel."
  (interactive)
  (setq tab-width 8)
  (setq indent-tabs-mode nil) ;; force spaces, to work with dumber editors
  (setq c-basic-offset 8))

(add-hook 'c-mode-hook 'vedang/linux-c-indent)
(add-hook 'c-mode-hook (lambda() (c-set-style "K&R")))
(add-hook 'c++-mode-hook 'vedang/linux-c-indent)

;; these are configuration files and should be opened in appropriate mode
(add-to-list 'auto-mode-alist '("\\.\\(mc\\|rc\\|def\\)$" . conf-mode))

;; customizations for auto-indentation
(defadvice yank (after indent-region activate)
  (if (member major-mode programming-major-modes)
      (let ((mark-even-if-inactive t))
        (indent-region (region-beginning) (region-end) nil))))

(defadvice yank-pop (after indent-region activate)
  (if (member major-mode programming-major-modes)
      (let ((mark-even-if-inactive t))
        (indent-region (region-beginning) (region-end) nil))))

;; settings for hippie-expand
(setq hippie-expand-try-functions-list
       '(try-expand-dabbrev
         try-expand-dabbrev-from-kill
         try-expand-dabbrev-all-buffers
         try-complete-file-name-partially
         try-complete-file-name
         try-complete-lisp-symbol-partially
         try-complete-lisp-symbol))

;; uniquify settings
(setq uniquify-buffer-name-style 'reverse)
(setq uniquify-separator "/")
(setq uniquify-after-kill-buffer-p t)
(setq uniquify-ignore-buffers-re "^\\*")

;; Aliases for common functions
(defalias 'qrr 'query-replace-regexp)
(defalias 'rvt 'revert-buffer)
(defalias 'dtw 'delete-trailing-whitespace)

;; Enable narrow-to-region, extremely useful for editing text
(put 'narrow-to-region 'disabled nil)

;; load this color-theme
(require 'color-theme)
(require 'color-theme-billw)
(color-theme-billw)

;; visual-line is good to have
(add-hook 'text-mode-hook 'turn-on-visual-line-mode)

;; when I create a temporary buffer, it should auto-detect the right
;; mode to start in the buffer
(setq default-major-mode (lambda ()
                           (let ((buffer-file-name (or buffer-file-name (buffer-name))))
                             (set-auto-mode))))

(auto-compression-mode t)
(show-paren-mode 1)
(provide 'customizations)
