;; Author: Simon Genier
;; URL: https://github.com/syl20bnr/spacemacs
;;
;;; License: GPLv3

;;; Code:

(defconst ruby-shopify-packages
  '(
    (ruby :location local :variables ruby-enable-enh-ruby-mode t ruby-version-manager 'chruby)
    ))

(defun ruby-shopify/init-ruby ()
  (use-package ruby
    :defer t
    :init (ruby-shopify//configure-ruby)))

;;; packages.el ends here
