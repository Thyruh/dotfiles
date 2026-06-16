(defun xd()
  "Wrapper around a personal tool called xd"
  (interactive)
  (setq args (read-shell-command "xd: "))
  (async-shell-command (format "xd %s" args))
  (sleep-for 0.1)
  (when (get-buffer "*Async Shell Command*")
    (select-window (get-buffer-window "*Async Shell Command*"))
	(beginning-of-buffer)
	(select-window (previous-window)))
)

