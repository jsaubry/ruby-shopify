;; Author: Simon Genier
;; URL: https://github.com/syl20bnr/spacemacs
;;
;;; License: GPLv3

;;; Code:

(defun ruby-shopify//file-name-in-project-root (file-name)
  (concat (file-name-as-directory (projectile-project-root)) file-name))

(defun ruby-shopify//read-ruby-version ()
  (lexical-let ((ruby-version-file-path (ruby-shopify//file-name-in-project-root ".ruby-version")))
    (cond
     ((file-exists-p ruby-version-file-path)
      (with-temp-buffer
        (insert-file-contents (ruby-shopify//ruby-version-file-path))
        (buffer-string)))
     (t ruby-shopify-default-version))))

(defun ruby-shopify//use-local-rubocop ()
  (lexical-let ((rubocop-path (ruby-shopify//file-name-in-project-root "bin/rubocop")))
    (when (file-executable-p rubocop-path)
      (setq flycheck-ruby-rubocop-executable rubocop-path))))

(defun ruby-shopify//enter-chruby ()
  (lexical-let ((ruby-version (ruby-shopify//read-ruby-version)))
    (chruby ruby-version)
    ruby-version))

(defun ruby-shopify//ruby-mode-hook ()
  (ruby-shopify//use-local-rubocop)
  ;; (lexical-let* ((delimiter-face-foreground (face-foreground 'enh-ruby-string-delimiter-face)))
  ;;   (set-face-foreground 'enh-ruby-regexp-delimiter-face delimiter-face-foreground)
  ;;   (set-face-foreground 'enh-ruby-heredoc-delimiter-face delimiter-face-foreground))
  (lexical-let* ((ruby-version (ruby-shopify//enter-chruby))
                 (ruby-version-directory (concat "/opt/rubies/" ruby-version))
                 (ruby-program (concat (file-name-as-directory ruby-version-directory) "bin/ruby")))
    (when (file-executable-p ruby-program)
      (setq enh-ruby-program ruby-program
            flycheck-ruby-executable ruby-program))))

(defun ruby-shopify//configure-ruby ()
  (setq enh-ruby-add-encoding-comment-on-save nil)
  (setq ruby-insert-encoding-magic-comment nil)
  (chruby ruby-shopify-default-version)
  (add-hook 'enh-ruby-mode-hook 'ruby-shopify//ruby-mode-hook t)
  (add-hook 'ruby-mode-hook 'ruby-shopify//ruby-mode-hook t)
  (remove-hook 'enh-ruby-mode-hook 'rubocop-mode)
  (remove-hook 'ruby-mode-hook 'rubocop-mode))

(defun ruby-shopify//rb-config (key)
  (lexical-let ((command (concat "ruby -e 'print(RbConfig::CONFIG[%(" key ")])'")))
    (shell-command-to-string command)))

;;; funcs.el ends here
