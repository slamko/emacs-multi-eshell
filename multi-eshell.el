(setq eshell-last-id nil)

(defun get-eshell-buf-name (num)
  (concat "*eshell*<" (number-to-string num) ">"))

(defun eshell-new-rec (cnt)
  (if (get-buffer (get-eshell-buf-name cnt))
	  (eshell-new-rec (+ cnt 1))
	  (eshell (setq eshell-last-id cnt))))

(defun eshell-new (&optional cnt)
  (interactive)
  (eshell-new-rec (or cnt 1)))

(defun eshell-last-rec (id)
  (if (and (get-buffer (get-eshell-buf-name id)) (not (equal eshell-last-id id)))
	  (eshell-last-rec (+ id 1))
	  (eshell (setq eshell-last-id id))))

(defun eshell-last (&optional id)
  (interactive)
  (let*
	  ((eshell-id (or id eshell-last-id))
	   (eshell-buf (get-buffer (get-eshell-buf-name eshell-id))))
	(message (buffer-name  eshell-buf))
    (if eshell-buf
	  (switch-to-buffer eshell-buf)
	  (eshell-last-rec 1))))

