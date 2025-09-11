;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;; Config
(add-to-list 'load-path "~/.emacs.d/packages")

(add-to-list 'backup-directory-alist '("." . "~/.emacs.d/backups") t)
(setq inhibit-startup-screen t)
(setq scroll-step 1)
(setq dabbrev-case-fold-search nil)
(setq fill-column 80)
(setq c-default-style "bsd")
(setq c-basic-offset 4)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(show-paren-mode 1)
;; (global-linum-mode 1)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(delete-selection-mode 1)
(savehist-mode 1)
(xterm-mouse-mode 1)
(unless (display-graphic-p)
  (menu-bar-mode -1))

;; Workaround for https://debbugs.gnu.org/cgi/bugreport.cgi?bug=45824, which
;; causes Emacs not to run screen.el when TERM=screen.xterm-256color.
(add-to-list 'term-file-aliases '("screen.xterm-256color" . "screen-256color"))
;; Enable Emacs to write to the system clipboard through OSC 52 codes.
(setq xterm-screen-extra-capabilities '(modifyOtherKeys setSelection))
(setq xterm-tmux-extra-capabilities '(modifyOtherKeys setSelection))

(require 'dired-x)

;; Bindings
(defmacro bind-args (fun &rest args)
  `(lambda () (interactive) (,fun ,@args)))

(global-set-key (kbd "<M-down>") 'scroll-up-line)
(global-set-key (kbd "<M-up>") 'scroll-down-line)
(global-set-key (kbd "M-n") 'scroll-up-line)
(global-set-key (kbd "M-p") 'scroll-down-line)
;; (global-set-key (kbd "<M-down>") (bind-args scroll-up-line 2))
;; (global-set-key (kbd "<M-up>") (bind-args scroll-down-line 2))
(global-set-key (kbd "<mouse-5>") (bind-args scroll-up-line 2))
(global-set-key (kbd "<mouse-4>") (bind-args scroll-down-line 2))

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
      (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
    (message "No text selected")))

(defun paste-from-clipboard ()
  (interactive)
  (insert (shell-command-to-string "xsel -o -b 2>/dev/null")))

(global-set-key (kbd "C-M-c") 'copy-to-clipboard)
(global-set-key (kbd "C-M-v") 'paste-from-clipboard)

;; Third-party
;; (global-undo-tree-mode 1)
;; (global-set-key (kbd "C-M-_") 'undo-tree-redo)
;; (global-set-key (kbd "C-\\") 'undo-tree-redo)
;; (setq undo-tree-auto-save-history nil)
;; (dtrt-indent-global-mode 1)
;; ;; (require 'cl)                           ; required for yascroll
;; (global-yascroll-bar-mode 1)
;; ;; (hlinum-activate)
;; (global-diff-hl-mode)
;; (diff-hl-margin-mode)
;; ;; (add-hook 'python-mode-hook 'jedi:setup)
;; ;; (setq jedi:complete-on-dot t)
;; ;; (global-set-key (kbd "M-;") 'smart-comment)
;; (whole-line-or-region-global-mode 1)

;; Customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-selected-packages
   '(diff-hl hlinum yascroll dtrt-indent undo-tree smart-comment whole-line-or-region)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(line-number ((t (:inherit (shadow default) :background "#333"))))
 '(line-number-current-line ((t (:inherit line-number :background "#555"))))
 '(linum ((t (:background "#999" :foreground "#000")))))
