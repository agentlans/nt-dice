;;     Copyright (C) 2020 Alan Tseng

;;     This program is free software: you can redistribute it and/or modify
;;     it under the terms of the GNU General Public License as published by
;;     the Free Software Foundation, either version 3 of the License, or
;;     (at your option) any later version.

;;     This program is distributed in the hope that it will be useful,
;;     but WITHOUT ANY WARRANTY; without even the implied warranty of
;;     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;     GNU General Public License for more details.

;;     You should have received a copy of the GNU General Public License
;;     along with this program.  If not, see <https://www.gnu.org/licenses/>.

(asdf:load-system 'screamer)
(asdf:load-system 'alexandria)

(screamer:define-screamer-package :dice)
(in-package :dice)

(defun beat-probability (die1 die2)
  "Returns the probability that die1 beats die2."
  (/ (loop for x across die1 sum
	;; Find how many elements y in die2 such that x > y
	  (let ((beatable
		 (position-if (lambda (y)
				(> x y))
			      die2 :from-end t)))
	    (if beatable (+ 1 beatable) 0)))
     (* (length die1) (length die2))))
;; (beat-probability #(1 2 3 4 5 6) #(3 3 3 3 3 3))

(defun vector-set (vec i x)
  "Returns a copy of vec where vec[i] has been set to x."
  (let ((y (alexandria:copy-array vec)))
    (setf (svref y i) x)
    y))

(defun replace-zeros (seq n)
  "Non-deterministically replaces 0 in seq with integer >= 1 and <= n."
  (let ((p (position 0 seq)))
    (cond ((not p) seq)
	  ((= p 0)
	   (replace-zeros
	    (vector-set seq 0 (an-integer-between 1 n))
	    n))
	  (t (let ((prev (svref seq (- p 1)))) ; previous element
	       (replace-zeros
		(vector-set seq p (an-integer-between prev n))
		n))))))

(defun an-increasing-sequence-below (len upper)
  "Returns a non-decreasing integer sequence of length len
such that for every element, 1 <= element <= upper."
  (replace-zeros (make-array len) upper))
;; (all-values (an-increasing-sequence-below 5 6))

;; These are helper functions for making the non-transitive triple
(defun make-die (num-sides max-val)
  "Returns a die with given number of sides and the values on
each side is between 1 and max-val inclusive."
  (an-increasing-sequence-below num-sides max-val))

(defun beats (die1 die2)
  "Returns true if die1 beats die2 with over 50% probability."
  (> (beat-probability die1 die2) 0.5))

(defun dice< (die1 die2)
  "Returns true if die1 < die2, comparing the sides of the dice sequentially."
  (let ((len (min (length die1) (length die2))))
    (do ((i 0 (+ i 1)))
	((or (= i len)
	     (not (= (svref die1 i) (svref die2 i))))
	 (if (= i len)
	     nil ; Reached end of vector
	     (< (svref die1 i) (svref die2 i)))))))

(defun a-nontransitive-triple
    (num-sides max-val &optional (print-dice nil))
  "Returns a set of three non-transitive dice
with the given number of sides and each side is between
1 and max-val, inclusive."
  (let ((d1 (make-die num-sides max-val))
	(d2 (make-die num-sides max-val))
	(d3 (make-die num-sides max-val)))
    (unless (and (dice< d1 d2)
		 (dice< d2 d3)
		 (beats d1 d2)
		 (beats d2 d3)
		 (beats d3 d1))
      (fail))
    (let ((soln (list d1 d2 d3)))
      (if print-dice
	  (print soln))
      soln)))

;; Returns three 6-sided non-transitive dice whose numbers
;; on the sides are >= 1 and <= 5.
;; (one-value (a-nontransitive-triple 6 5))

;; Returns all triplets of dice as described above,
;; printing them as they are found.
;; (all-values (a-nontransitive-triple 6 5 t))
