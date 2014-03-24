;; rbenv
(if (file-exists-p "~/.rbenv")
    (setq exec-path (cons "~/.rbenv/bin" exec-path))
    (setenv "PATH" (concat "~/.rbenv/bin:" (getenv "PATH")))
    (setq exec-path (cons "~/.rbenv/shims" exec-path))
    (setenv "PATH" (concat "~/.rbenv/shims:" (getenv "PATH"))))

;; TODO determine which versions should be used in the project
(setq enh-ruby-program "~/.rbenv/versions/2.0.0-p353/bin/ruby")

(autoload 'enh-ruby-mode "enh-ruby-mode" "Major mode for ruby files" t)

(add-to-list 'auto-mode-alist '("\\.rake$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("\\.ru$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))

(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))

(setq enh-ruby-bounce-deep-indent t)

(defun* get-closest-gemfile-root (&optional (file "Gemfile"))
  "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
of FILE in the current directory, suitable for creation"
  (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
    (loop 
     for d = default-directory then (expand-file-name ".." d)
     if (file-exists-p (expand-file-name file d))
     return d
     if (equal d root)
     return nil)))

(require 'compile)

(defun rspec-compile-file ()
  (interactive)
  (compile (format "cd %s;bundle exec rspec %s"
                   (get-closest-gemfile-root)
                   (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
                   ) t))

(defun rspec-compile-on-line ()
  (interactive)
  (compile (format "cd %s;bundle exec rspec %s -l %s"
                   (get-closest-gemfile-root)
                   (file-relative-name (buffer-file-name) (get-closest-gemfile-root))
                   (line-number-at-pos)
                   ) t))

(add-hook 'enh-ruby-mode-hook
          (lambda ()
            (local-set-key (kbd "C-c l") 'rspec-compile-on-line)
            (local-set-key (kbd "C-c k") 'rspec-compile-file)
            ))

;; Smartparents config
(require 'smartparens-config)
(smartparens-global-mode)
(show-smartparens-global-mode t)

;; Coffee mode config
(defun coffee-mode-custom ()
  "coffee-mode-hook"
  (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook
	  '(lambda() (coffee-custom)))


;; Highlight Indentation config
(require 'highlight-indentation)
(set-face-background 'highlight-indentation-face "#e3e3d3")
(set-face-background 'highlight-indentation-current-column-face "#c3b3b3")

(add-hook 'enh-ruby-mode-hook
           (lambda () (highlight-indentation-current-column-mode)))
(add-hook 'coffee-mode-hook
           (lambda () (highlight-indentation-current-column-mode)))

