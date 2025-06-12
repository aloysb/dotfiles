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

(use-package recentf
:ensure nil  ;; it's built-in
:init
(recentf-mode 1)
:custom
(recentf-max-menu-items 25)
(recentf-max-saved-items 100)
(recentf-auto-cleanup 'never)) ;; disables cleanup which can sometimes remove useful entries

(use-package vertico
        :init
        (vertico-mode)
       )

(use-package marginalia
  :after vertico
  :init

  (marginalia-mode))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :custom
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (orderless-style-dispatchers '(+orderless-consult-dispatch orderless-affix-dispatch))
  ;; (orderless-component-separator #'orderless-escapable-split-on-space)
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion))))
)

(use-package consult
:bind (
("C-c b" . consult-buffer)
("C-c o" . consult-recent-file)
)
)

(defun reload-config ()
  "reload the configuration"
  (interactive)
  (load-file user-init-file)
)

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

;; Turn on line numbers
(global-display-line-numbers-mode t)
(menu-bar--display-line-numbers-mode-relative)

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

(use-package general
 :ensure t
 :config
 (general-create-definer leader-def
   :prefix "SPC")
 (leader-def
   :keymaps 'normal ;;this is related to evil
   "a" 'org-agenda
   "SPC" 'consult-buffer
   "c" 'org-capture
 )
)

(defun meow-setup ()
 (setq meow-cheatsheet-layout meow-cheatsheet-layout-colemak-dh)
 (meow-motion-define-key
  ;; Use e to move up, n to move down.
  ;; Since special modes usually use n to move down, we only overwrite e here.
  '("e" . meow-prev)
  '("<escape>" . ignore))
 (meow-leader-define-key
  '("?" . meow-cheatsheet)
  '("1" . meow-digit-argument)
  '("2" . meow-digit-argument)
  '("3" . meow-digit-argument)
  '("4" . meow-digit-argument)
  '("5" . meow-digit-argument)
  '("6" . meow-digit-argument)
  '("7" . meow-digit-argument)
  '("8" . meow-digit-argument)
  '("9" . meow-digit-argument)
  '("0" . meow-digit-argument))
 (meow-normal-define-key
  '("0" . meow-expand-0)
  '("1" . meow-expand-1)
  '("2" . meow-expand-2)
  '("3" . meow-expand-3)
  '("4" . meow-expand-4)
  '("5" . meow-expand-5)
  '("6" . meow-expand-6)
  '("7" . meow-expand-7)
  '("8" . meow-expand-8)
  '("9" . meow-expand-9)
  '("-" . negative-argument)
  '(";" . meow-reverse)
  '("," . meow-inner-of-thing)
  '("." . meow-bounds-of-thing)
  '("[" . meow-beginning-of-thing)
  '("]" . meow-end-of-thing)
  '("/" . meow-visit)
  '("a" . meow-append)
  '("A" . meow-open-below)
  '("b" . meow-back-word)
  '("B" . meow-back-symbol)
  '("c" . meow-change)
  '("e" . meow-prev)
  '("E" . meow-prev-expand)
  '("f" . meow-find)
  '("g" . meow-cancel-selection)
  '("G" . meow-grab)
  '("m" . meow-left)
  '("M" . meow-left-expand)
  '("i" . meow-right)
  '("I" . meow-right-expand)
  '("j" . meow-join)
  '("k" . meow-kill)
  '("l" . meow-line)
  '("L" . meow-goto-line)
  '("h" . meow-mark-word)
  '("H" . meow-mark-symbol)
  '("n" . meow-next)
  '("N" . meow-next-expand)
  '("o" . meow-block)
  '("O" . meow-to-block)
  '("p" . meow-yank)
  '("q" . meow-quit)
  '("r" . meow-replace)
  '("s" . meow-insert)
  '("S" . meow-open-above)
  '("t" . meow-till)
  '("u" . meow-undo)
  '("U" . meow-undo-in-selection)
  '("v" . meow-search)
  '("w" . meow-next-word)
  '("W" . meow-next-symbol)
  '("x" . meow-delete)
  '("X" . meow-backward-delete)
  '("y" . meow-save)
  '("z" . meow-pop-selection)
  '("'" . repeat)
  '("<escape>" . ignore)))
 
  (use-package meow
    :ensure t
    :config
    (meow-setup)
    (meow-global-mode 1)
  )

(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t) ;; C-u to scroll up, same as vim
  (setq evil-want-Y-yank-to-eol t) ;; Y to yank line, same as vim
  (setq evil-move-cursor-back nil) ;; Don't go back when exiting edit mode
  (setq evil-want-C-i-jump t) ;; C-i to jump forward
  :config
  (evil-mode 0)
 )

(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init)
  )

(use-package transient)

  (use-package magit
       :after transient
    )
