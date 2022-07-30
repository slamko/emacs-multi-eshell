(setq eshell-last-id nil)
(setq eshell-max-id 0) 

(defun get-eshell-buf-name (num)
  (concat "*eshell*<" (number-to-string num) ">"))

(defun eshell-new-rec (cnt)
  (if (get-buffer (get-eshell-buf-name cnt))
	  (eshell-new-rec (+ cnt 1))
	  (eshell
	   (progn
		 (when (> cnt eshell-max-id)
		   (setq eshell-max-id cnt))
		 (setq eshell-last-id cnt)))))

(defun eshell-new (&optional cnt)
  (interactive)
  (eshell-new-rec (or cnt 1)))

(defun eshell-last-rec (id &optional ebuffer)
  (if (equal eshell-max-id id)
	  (if ebuffer
		  (switch-to-buffer ebuffer)
		(eshell (setq eshell-last-id 1)))
	(eshell-last-rec (+ id 1) (get-buffer (get-eshell-buf-name id)))))

(defun eshell-last (&optional id)
  (interactive)
  (let*
	  ((eshell-id (or id eshell-last-id))
	   (eshell-buf (get-buffer (get-eshell-buf-name eshell-id))))
    (if eshell-buf
	  (switch-to-buffer eshell-buf)
	  (eshell-last-rec 1))))

