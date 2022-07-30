;; multi-eshell.el - GNU Emacs extension for managing multiple eshell buffers. 

;; Copyright (C) 2022 Viacheslav Chepelyk-Kozhin.
;;
;; This program is free software: you can redistribute it and/or modify it under
;; the terms of the GNU General Public License as published by the Free Software
;; Foundation, either version 3 of the License, or (at your option) any later version.
;; This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
;; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
;; See the GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.

(defvar-local ees--eshell-last-id nil
  "Last identifier for eshell buffer")

(defvar ess--eshell-max-id 0
  "Amount of eshell buffers created with ees") 

(defun ees--get-eshell-buf-name (num)
  "Get the name of the buffer created with ees/eshell-new where NUM is the buffer id."
  (concat "*eshell*<" (number-to-string num) ">"))

(defun ees--eshell-new-rec (cnt)
  (if (get-buffer (get-eshell-buf-name cnt))
	  (eshell-new-rec (+ cnt 1))
	  (eshell
	   (progn
		 (when (> cnt eshell-max-id)
		   (setq eshell-max-id cnt))
		 (setq eshell-last-id cnt)))))

(defun ees/eshell-new (&optional buf-id)
  "Create new eshell buffer with the minimal available id. You can specify buffer id explicitly with an optional BUF-ID argument."x
  (interactive)
  (eshell-new-rec (or buf-id 1)))

(defun ees--eshell-last-rec (id &optional ebuffer)
  (if (equal eshell-max-id id)
	  (if ebuffer
		  (switch-to-buffer ebuffer)
		(eshell (setq eshell-last-id 1)))
	(eshell-last-rec (+ id 1) (get-buffer (get-eshell-buf-name id)))))

(defun ees/eshell-last (&optional id)
  "Switch to last available eshell buffer. If no eshell buffers found - create one.
Optionally accepts ID of the eshell buffer to switch directly."
  (interactive)
  (let*
	  ((eshell-id (or id eshell-last-id))
	   (eshell-buf (get-buffer (get-eshell-buf-name eshell-id))))
    (if eshell-buf
	  (switch-to-buffer eshell-buf)
	  (eshell-last-rec 1))))

(provide 'emacs-multi-eshell)
