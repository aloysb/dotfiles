;; init.el --- the init.lua of emacs
;;
;; This file loads Org and then load the rest of my emacs config embedded in my
;; config.org using babel
(setq emacs-config-dir (file-name-directory (or (buffer-file-name) load-file-name)))

;; load up org and org-babel
(require 'org)
(require 'ob-tangle)
;; load the config.org file and tangle it into config.el
(org-babel-load-file
   (expand-file-name "config.org" emacs-config-dir)
)

;; init.el ends here
