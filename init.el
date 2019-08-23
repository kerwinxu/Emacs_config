;; ----------------------------------------------------------------------------
;;通用配置
(setq inhibit-startup-message t) ;; hide the startup message
(global-linum-mode t) ;; enable line numbers globally
(global-set-key (kbd "M-g") 'goto-line) ;;设置M-g为goto-line
(show-paren-mode t);;显示括号匹配
(setq frame-title-format "%b@emacs");在最上方的标题栏显示当前buffer的名字
(setq x-select-enable-clipboard t);; 支持emacs和外部程序之间进行粘贴
(fset 'yes-or-no-p 'y-or-n-p);以 'y/n'字样代替原默认的'yes/no'字样
;设置中文语言环境
(set-language-environment 'Chinese-GB)
;;写文件的编码方式
;;(set-buffer-file-coding-system 'gb2312)
(set-buffer-file-coding-system 'utf-8)
;;新建文件的编码方式
;;(setq default-buffer-file-coding-system 'gb2312)
(setq default-buffer-file-coding-system 'utf-8)
;;终端方式的编码方式
(set-terminal-coding-system 'utf-8)
;;键盘输入的编码方式
;;(set-keyboard-coding-system 'gb2312)
;;读取或写入文件名的编码方式
(setq file-name-coding-system 'utf-8)
 
(electric-pair-mode t);;自动补全括号等" ' “” ‘’ () {} [] «» ‹› 「」

;;一定要设置如下的字体，否则有中文就会卡死的。
;; Setting English Font
(set-face-attribute
 'default nil :font "Consolas 10")

;; Chinese Font
(dolist (charset '(kana han symbol cjk-misc bopomofo))
  (set-fontset-font (frame-parameter nil 'font)
		    charset
		    (font-spec :family "Microsoft Yahei" :size 12)))
;; ----------------------------------------------------------------------------
;; INSTALL PACKAGES
(require 'package)
(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
;;(add-to-list 'package-archives  '("elpy" . "https://jorgenschaefer.github.io/packages/"))

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))
;;如果没有安装这个use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;;先设置界面吧，毕竟界面好看些
(use-package material-theme
  :init
  (load-theme 'material t) ;; load material theme
  )
;;我要用邪恶模式,毕竟想用vim啊
(use-package evil
  :ensure t
  :config

  (evil-mode 1)
  (use-package evil-leader
    :ensure t
    :config
    (global-evil-leader-mode t)
    (evil-leader/set-leader "<SPC>")
    (evil-leader/set-key
      "s s" 'swiper
      "d x w" 'delete-trailing-whitespace))

  (use-package evil-surround
    :ensure t
    :config (global-evil-surround-mode))

  (use-package evil-indent-textobject
    :ensure t)

  (use-package evil-org
    :ensure t
    :config
    (evil-org-set-key-theme
	  '(textobjects insert navigation additional shift todo heading))
    (add-hook 'org-mode-hook (lambda () (evil-org-mode))))

  (use-package powerline-evil
    :ensure t
    :config
    (powerline-evil-vim-color-theme)))
;;然后是lisp的slime
(use-package slime
  :ensure t
  :init
  (use-package slime-company
    :ensure t)
  (setq inferior-lisp-program "D:/Program Files/Steel Bank Common Lisp/1.4.2/sbcl.exe");设置优先使用哪种Common Lisp实现
  (slime-setup'(slime-fancy slime-company))
  (require  'slime-autoloads)
  )
;; ----------------------------------------------------------------------------
;;如下是自动补全的,我暂时用company
(use-package company
  :ensure t
  :init
  (global-company-mode t); 全局开启
  :config
  (setq company-idle-delay 0.2);菜单延迟
  (setq company-minimum-prefix-length 1) ; 开始补全字数
  (setq company-require-match nil)
  (setq company-dabbrev-ignore-case nil)
  (setq company-dabbrev-downcase nil)
  (setq company-show-numbers t)
  (setq company-transformers '(company-sort-by-backend-importance)
	company-continue-commands '(not helm-dabbrev)
	)
					; (add-hook 'python-mode-hook 'disable_company)
  ;;
  ;; 补全后端使用anaconda,如果是python，后边会设置成jedi
  ;;(add-to-list 'company-backends '(company-anaconda :with company-yasnippet))
  
					; 补全快捷键
  (global-set-key (kbd "<C-itab>") 'company-complete)
					; 补全菜单选项快捷键
  ;;(define-key company-active-map (kbd "C-n") 'company-select-next)
  ;;(define-key company-active-map (kbd "C-p") 'company-select-previous)
  (setq company-tooltip-align-annotations t);左右对齐
  (setq company-transformers '(company-sort-by-occurrence));频次排序
  
  )
;; 有时候需要关闭这个。
(defun disable_company()
  (global-company-mode nil); 全局close,这个关闭不了啊。
  (setq company-backends nil)  
  )

;;搜索的
(use-package helm :ensure t
	:init
	(require 'helm-config)
	(require 'helm-grep)
	(helm-mode 1) 
	:bind
	("M-x" . helm-M-x)
	("C-x C-f" . helm-find-files)
)

(use-package magit :ensure t)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (magit evil-ediff ivy slime-company slime evil material-theme use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
