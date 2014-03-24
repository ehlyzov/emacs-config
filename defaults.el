(add-to-list 'exec-path "/usr/local/bin")

;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(defvar autosave-dir "~/.emacs.d/autosaves/")
(make-directory autosave-dir t)
(setq auto-save-file-name-transforms `((".*" ,(concat autosave-dir "\\1") t)))

;; y/n instead of yes/no
(defalias 'yes-or-no-p 'y-or-n-p)    

;; Disable backups
(setq backup-inhibited t)

;; To get rid of Weird color escape sequences in Emacs.
;; Instruct Emacs to use emacs term-info not system term info
;; http://stackoverflow.com/questions/8918910/weird-character-zsh-in-emacs-terminal
(setq system-uses-terminfo nil)

;; Prefer utf-8 encoding
(prefer-coding-system 'utf-8)

;; Running save-buffer automatically
(defun save-buffer-if-visiting-file (&optional args)
  "Save the current buffer only if it is visiting a file"
  (interactive)
  (if (buffer-file-name)
      (save-buffer args)))
(add-hook 'auto-save-hook 'save-buffer-if-visiting-file)
