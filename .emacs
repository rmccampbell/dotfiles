;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Config
(add-to-list 'load-path "~/.emacs.d/packages")

(setq-default c-default-style "k&r")
(setq-default c-basic-offset 4)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq inhibit-startup-screen t)
(setq scroll-step 1)
(setq dabbrev-case-fold-search nil)

(show-paren-mode 1)
(global-linum-mode 1)
(column-number-mode 1)
(delete-selection-mode 1)
(savehist-mode 1)
(xterm-mouse-mode 1)

;; Bindings
(defmacro bind-args (fun &rest args)
  `(lambda () (interactive) (,fun ,@args)))

(global-set-key (kbd "<M-down>") 'scroll-up-line)
(global-set-key (kbd "<M-up>") 'scroll-down-line)
;; (global-set-key (kbd "<M-down>") (bind-args scroll-up-line 2))
;; (global-set-key (kbd "<M-up>") (bind-args scroll-down-line 2))
(global-set-key (kbd "<mouse-5>") (bind-args scroll-up-line 2))
(global-set-key (kbd "<mouse-4>") (bind-args scroll-down-line 2))
;; (set-face-attribute 'linum nil :background "#999")
;; (set-face-attribute 'linum nil :foreground "#000")

;; Enabled
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'scroll-left 'disabled nil)

;; Hooks
(add-hook 'c-mode-hook (lambda () (setq comment-start "//"
                                        comment-end   "")))
(add-hook 'asm-mode-hook (lambda () (setq indent-tabs-mode t
                                          tab-width 8)))
(add-hook 'text-mode-hook (lambda () (setq indent-tabs-mode t
                                           tab-width 8)))
(add-hook 'nxml-mode-hook (lambda () (setq indent-tabs-mode nil)))

(add-to-list 'auto-mode-alist '("\\.ibcm$" . asm-mode))

;; Functions
(defun copy-to-clipboard ()
  (interactive)
  (if (region-active-p)
      (shell-command-on-region
       (region-beginning) (region-end) "xsel -i -b")
    (message "No text selected")))

(defun paste-from-clipboard ()
  (interactive)
  (insert (shell-command-to-string "xsel -o -b")))

(global-set-key (kbd "C-M-c") 'copy-to-clipboard)
(global-set-key (kbd "C-M-v") 'paste-from-clipboard)

;; Third-party
;; (global-undo-tree-mode 1)
;; (global-set-key (kbd "C-M-_") 'undo-tree-redo)
;; (global-set-key (kbd "C-\\") 'undo-tree-redo)
;; (require 'cl)                           ; required for yascroll
;; (global-yascroll-bar-mode 1)

;; Customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 ;; '(dtrt-indent-mode t nil (dtrt-indent))
 '(package-archives
   (quote
    (("gnu" . "http://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.org/packages/"))))
 '(package-selected-packages (quote (yascroll dtrt-indent undo-tree))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(linum ((t (:background "#999" :foreground "#000")))))
