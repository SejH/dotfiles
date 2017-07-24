;;; Code:
;; Packages

;; C-h v package-activated-list
(setq package-list '(ac-emmet auto-complete popup emmet-mode ac-js2 skewer-mode js2-mode simple-httpd js2-mode auto-complete popup context-coloring emmet-mode emoji-cheat-sheet-plus helm helm-core async popup async eslint-fix esxml exec-path-from-shell flycheck seq let-alist pkg-info epl dash flymd git f dash s dash s git-command with-editor dash async term-run go-mode golden-ratio google-this haskell-mode helm helm-core async popup async helm-core async js-comint js-doc js2-refactor yasnippet s dash multiple-cursors s js2-mode json-mode json-snatcher json-reformat json-reformat json-snatcher jsx-mode let-alist lorem-ipsum lua-mode magit magit-popup dash async git-commit with-editor dash async dash with-editor dash async dash async magit-popup dash async mkdown markdown-mode multiple-cursors nginx-mode nodejs-repl pkg-info epl popup s seq skewer-mode js2-mode simple-httpd spotify swift-mode term-run typescript-mode uuidgen vlf web-mode with-editor dash async yaml-mode yasnippet))

;; ;;**************************************************
;; ;; Emacs packages
; list the repositories containing them
(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))

; activate all the packages (in particular autoloads)
(package-initialize)

; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install the missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))



(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(setq read-file-name-completion-ignore-case t)

;**************************************************
;; use Shift+arrow_keys to move cursor around split panes
(windmove-default-keybindings)

;; when cursor is on edge, move to the other sidebare, as in a toroidal space
(setq windmove-wrap-around t)

;**************************************************
; Search on google
(global-set-key (kbd "C-x g") 'google-this)

;;**************************************************
;; Emmet/zen mode
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; Fuzzy
(ido-mode t)

;;**************************************************
;; Marking for windows and stuff

(global-hl-line-mode 1)
(set-face-background hl-line-face "gray13")
(set-face-attribute 'region nil :background "#111")

(set-face-attribute  'mode-line
                 nil
                 :foreground "gray90"
                 :background "gray50"
                 :box '(:line-width 1 :style released-button))

(set-face-attribute  'mode-line-inactive
                 nil
                 :foreground "gray30"
                 :background "gray50"
                 :box '(:line-width 1 :style released-button))

(if (eq system-type 'darwin)
    (setq mac-option-modifier nil
          mac-command-modifier 'meta
          x-select-enable-clipboard t)
  )

;; turn on automatic bracket insertion by pairs. New in emacs 24
(electric-pair-mode 1)

;**************************************************
; ff, find text in files hotkey

(global-set-key (kbd "C-=") 'find-grep)


(define-key input-decode-map [?\C-i] [C-i])

(global-set-key (kbd "<C-i>") 'indent-region)
(global-set-key "\C-co" 'occur)


;**************************************************
; Backup stuffs!

(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)

;; List yank history
(global-set-key "\C-cy" '(lambda ()
   (interactive)
   (popup-menu 'yank-menu)))


;;Calendar diary
(setq view-diary-entries-initially t
      mark-diary-entries-in-calendar t
      number-of-diary-entries 7)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)

(add-hook 'fancy-diary-display-mode-hook
	   '(lambda ()
              (alt-clean-equal-signs)))

(defun alt-clean-equal-signs ()
  "This function makes lines of = signs invisible."
  (goto-char (point-min))
  (let ((state buffer-read-only))
    (when state (setq buffer-read-only nil))
    (while (not (eobp))
      (search-forward-regexp "^=+$" nil 'move)
      (add-text-properties (match-beginning 0)
                           (match-end 0)
                           '(invisible t)))
    (when state (setq buffer-read-only t))))


(define-derived-mode fancy-diary-display-mode  fundamental-mode
  "Diary"
  "Major mode used while displaying diary entries using Fancy Display."
  (set (make-local-variable 'font-lock-defaults)
       '(fancy-diary-font-lock-keywords t))
  (define-key (current-local-map) "q" 'quit-window)
  (define-key (current-local-map) "h" 'calendar))

(defadvice fancy-diary-display (after set-mode activate)
  "Set the mode of the buffer *Fancy Diary Entries* to
 `fancy-diary-display-mode'."
  (save-excursion
    (set-buffer fancy-diary-buffer)
    (fancy-diary-display-mode)))

;;#######################################################
;; Improved JavaScript stuff

;;  customize-group

;; Start scratch buffer with js2-mode
(setq initial-major-mode 'js2-mode)
(setq initial-scratch-message nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("c924950f6b5b92a064c5ad7063bb34fd3facead47cd0d761a31e7e76252996f7" "67a0265e2497207f5f9116c4d2bfbbab4423055e3ab1fa46ea6bd56f7e322f6a" default)))
 '(ede-project-directories (quote ("/home/safton/workspace/emacs")))
 '(erc-modules
   (quote
    (autojoin button completion fill irccontrols list match menu move-to-prompt netsplit networks noncommands readonly ring smiley stamp spelling track)))
 '(inhibit-startup-screen t)
 '(js2-basic-offset 2)
 '(js2-bounce-indent-p t)
 '(js2-idle-timer-delay 0.5)
 '(js2-indent-switch-body t)
 '(js2r-prefered-quote-type 2)
 '(js2r-use-strict t)
 '(web-mode-code-indent-offset 2)
 '(web-mode-markup-indent-offset 2))

;; Search on mdn
(defun search-mdn(query)
  (interactive "sSearch mdn: ")
  (browse-url (concat "https://mdn.io/" query)))
(global-set-key (kbd "C-c m") 'search-mdn)

; JavaScript mode
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))

;; js-doc
;; (require 'js-doc)

(setq js-doc-mail-address "pellem.92@gmail.com"
      js-doc-author (format "Pelle Mattsson <%s>" js-doc-mail-address)
      js-doc-url "https://pelle.xyz"
      js-doc-license "MIT")

(add-hook 'js2-mode-hook
	  #'(lambda ()
	      (define-key js2-mode-map "\C-ci" 'js-doc-insert-function-doc)
	      (define-key js2-mode-map "@" 'js-doc-insert-tag)
              (define-key js2-mode-map "\C-cj" 'js2-jump-to-definition)))

; Bind super key to options
; (setq mac-option-modifier 'super)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-m")

;; (add-hook 'js2-mode-hook 'ac-js2-mode)
;; (add-hook 'js2-mode-hook 'auto-complete-mode)


;; Move selected line up or down
(define-key js2-refactor-mode-map (kbd "s-<up>") 'js2r-move-line-up)
(define-key js2-refactor-mode-map (kbd "s-<down>") 'js2r-move-line-down)

;; http://www.flycheck.org/manual/latest/index.html
(require 'flycheck)

;; turn on flychecking globally
;; (add-hook 'after-init-hook #'global-flycheck-mode)
(global-flycheck-mode)

;; disable jshint since we prefer eslint checking
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(javascript-jshint)))

;; use eslint with web-mode for jsx files
(flycheck-add-mode 'javascript-eslint 'web-mode)

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; disable json-jsonlist checking for json files
(setq-default flycheck-disabled-checkers
  (append flycheck-disabled-checkers
    '(json-jsonlist)))

;; https://github.com/purcell/exec-path-from-shell
;; only need exec-path-from-shell on OSX
;; this hopefully sets up path and other vars better
(when (memq window-system '(mac ns))
  (exec-path-from-shell-initialize))

;;#######################################################


;; (load-theme 'monokai t)
(load-theme 'zenburn t)

;; ;; JavaScript:
;; Remove trailing white
(add-hook 'js2-mode-hook
          (lambda () (add-to-list 'write-file-functions 'delete-trailing-whitespace)))

;; use web-mode for .jsx files
(add-to-list 'auto-mode-alist '("\\.jsx$" . web-mode))

;; adjust indents for web-mode to 2 spaces
(defun my-web-mode-hook ()
  "Hooks for Web mode. Adjust indents"
  ;;; http://web-mode.org/
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 2))
(add-hook 'web-mode-hook  'my-web-mode-hook)


;; for better jsx syntax-highlighting in web-mode
;; - courtesy of Patrick @halbtuerke
(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))

(global-set-key (kbd "<f6>") 'magit-blame)


(global-set-key (kbd "<f8>") 'spotify-playpause)
(global-set-key (kbd "<f7>") 'spotify-previous)
(global-set-key (kbd "<f9>") 'spotify-next)
(if (not (eq system-type 'darwin))
    (spotify-enable-song-notifications)
  )


;; (global-set-key (kbd "<f7>") 'hs-show-block)
;; (global-set-key (kbd "<f8>") 'hs-hide-all)

(defun toggle-fullscreen (&optional f)
  (interactive)
  (let ((current-value (frame-parameter nil 'fullscreen)))
       (set-frame-parameter nil 'fullscreen
                            (if (equal 'fullboth current-value)
                                (if (boundp 'old-fullscreen) old-fullscreen nil)
                                (progn (setq old-fullscreen current-value)
                                       'fullboth)))))

(global-set-key [f5] 'toggle-fullscreen)


; M-n/M-p to scroll
(global-set-key "\M-n"  (lambda () (interactive) (scroll-up   10)) )
(global-set-key "\M-p"  (lambda () (interactive) (scroll-down 10)) )


(defun hide-menu(x)
  (interactive "n")
  (menu-bar-mode x)
  (toggle-scroll-bar x)
  (tool-bar-mode x))

(hide-menu -1)

(autoload 'linum-mode "linum" "toggle line numbers on/off" t)
(global-linum-mode 1)


;; (set-default-font "-*-fixed-*-r-normal-*-10-*-*-*-*-*-iso8859-*")
(set-default-font "-*-fixed-*-r-normal-*-10-*-*-*-*-*-iso8859-*")

;; No annoying messages at startup, thank you very much.
(setq inhibit-default-init t)
(setq inhibit-startup-message t)


;; Highlight matching parenthesis
(load "paren")
(show-paren-mode 1)

(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; Handle char codes 128+
(set-input-mode (car (current-input-mode))
                     (nth 1 (current-input-mode))
                     0)

;; Delete to remove all marked text
(delete-selection-mode t)

;; Delete and navigate camelCase
(add-hook 'prog-mode-hook 'subword-mode)

(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
(setq c-basic-offset 2)

(setq-default indent-tabs-mode nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(js2-external-variable ((t (:foreground "#DFAF8F"))))
 '(js2-function-param ((t (:foreground "#DFAF8F")))))


(defalias 'yes-or-no-p 'y-or-n-p)

(put 'downcase-region 'disabled nil)

(defun insert-current-date () (interactive)
 (insert (shell-command-to-string "echo -n $(date +%d-%m-%Y)")))

(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)

(global-set-key (kbd "C-s-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "C-s-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "C-s-<down>") 'shrink-window)
(global-set-key (kbd "C-s-<up>") 'enlarge-window)

(yas-reload-all)

(split-window-right)
(split-window-right)