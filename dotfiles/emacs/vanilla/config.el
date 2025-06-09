(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
   ;; Enable Elpaca support for use-package's :ensure keyword.

   (elpaca-use-package-mode))

;; always ensure that packages are installed. Replace the need to add :ensure t at the package level
      (require 'use-package-ensure)
      (setq use-package-always-ensure t)

(setq evil-want-keybinding nil)
(use-package evil
   :demand t
   :config
   (evil-mode 0)
   )

(use-package evil-collection
  :init (evil-collection-init)
  :disabled
)

(use-package vertico
        :init
        (vertico-mode)
       )

(use-package marginalia
  :after vertico
  :init

  (marginalia-mode))

(setq emacs-config-dir (file-name-directory user-init-file))
(setq config-org (expand-file-name "config.org" emacs-config-dir))

(defun open-config ()
  "open the configuration file for editing"
  (interactive)
  (find-file config-org)
 )

;; In your daemon's init.el or the config.org loaded by it
;; Disable ring bell
(setq ring-bell-function #'ignore)

;; Disable menu, toolbar, scrollbar...
(when (display-graphic-p)
  ;; These commands affect the current state and set some defaults
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)

  ;; These explicitly ensure ALL new frames adhere to these settings
  (add-to-list 'default-frame-alist '(menu-bar-lines . 0))
  (add-to-list 'default-frame-alist '(tool-bar-lines . 0))
  (add-to-list 'default-frame-alist '(vertical-scroll-bars . nil)) ;; Use nil for scroll bars

  ;; Your existing setting for undecorated frames (borderless)
  ;; This is a separate aesthetic choice.
  (add-to-list 'default-frame-alist '(undecorated . t))

  ;; add a hook to yet again, reload the config on new frames.
)
(add-hook 'server-after-make-frame-hook #'reload-config)

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)
 )

(use-package nerd-icons
;; :custom
;; The Nerd Font you want to use in GUI
;; "Symbols Nerd Font Mono" is the default and is recommended
;; but you can use any other Nerd Font if you want
;; (nerd-icons-font-family "Symbols Nerd Font Mono")
)

(use-package transient)

  (use-package magit
       :after transient
    )
