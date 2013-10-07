;;; jabber-tmux.el --- tmux integration for jabber.el

;; Copyright (C) 2013 James Andariese

;; Author: James Andariese <james@strudelline.net>
;; Version: 1.3
;; Keywords: jabber tmux

;;; Commentary:

;; This package provides a command for getting away time from tmux (currently that's it).
;; Activate auto-away method by setting jabber-autoaway-method to jabber-tmux-idle-time
;; (custom-set-variables
;;  ...
;;  '(jabber-autoaway-method (quote jabber-tmux-idle-time))
;;  ...)
;; This can also be done in M-x customize-variable jabber-autoaway-method
;;; Code:

(require 'cl)

;;;###autoload
(defun jabber-tmux-idle-time ()
  "Idle time based on last seen usage of tmux sessions.
Returns jabber-tmux-disconnected-idle-time if there are no connected sessions"
  (interactive)
  (let ((lines (process-lines "tmux" "list-clients" "-F" "#{client_activity}")))
    (let ((max-time (apply 'max (mapcar 'string-to-number lines))))
           ; this did more -- now it's just string-to-number and max
           ; don't think we'll need this anymore but maybe there will be more processing...
           ; delete this once it's in source control
           ;(reduce (lambda (x y) 
	   ;	     (let ((y (string-to-number y)))
	   ;	       (if (> x y) x y)))
	   ;	   lines
	   ;	   :initial-value 0)))
      (let ((seconds (if (> max-time 0)
			 (ceiling (- (float-time) max-time))
		       jabber-tmux-disconnected-idle-time)))
	seconds))))

;;;###autoload
(defgroup jabber-tmux nil
  "tmux integration for jabber.el"
  :group 'jabber)

;;;###autoload
(defcustom jabber-tmux-disconnected-idle-time
  1000000
  "Default time in seconds to report when tmux has no clients connected at all"
  :group 'jabber-autoaway
  :type '(number))

;;; jabber-tmux.el ends here.
