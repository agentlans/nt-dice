# nt-dice
Generates sets of non-transitive dice

Definition:
- A die D1 beats another die D2 if D1 > D2 with probability greater than 0.5.
- A set of dice A, B, C are non-transitive if A beats B and B beats C but A doesn't beat C.
- A set of dice A, B, C are strongly non-transitive if A beats B, B beats C, and C beats A.

This program generates sets of strongly non-transitive dice.

## Install
Requires Common Lisp and the following packages:
- `alexandria`
- `screamer`

Otherwise no installation required.

## Use
Go to the same directory as the source code and run the following in Lisp:

```lisp
(load "dice.lisp")
(in-package :dice)

;; Get sets of six-sided dice with maximum value of 5 on each face.
;; (all-values is a function from the Screamer package)
(all-values (a-nontransitive-triple 6 5)))
```

May take 1 minute to return output.

Example output.
- Each row represents a set of dice.
- Vectors in each row represents dice in the set.
- Numbers represent numbers on each face of the die.
```lisp
((#(1 1 2 4 4 4) #(1 3 3 3 3 3) #(2 2 2 2 5 5))
 (#(1 1 3 4 4 4) #(1 3 3 3 3 3) #(2 2 2 2 5 5))
 (#(1 1 3 4 4 4) #(2 3 3 3 3 3) #(2 2 2 2 5 5))
 (#(1 1 4 4 4 4) #(1 3 3 3 3 3) #(2 2 2 2 5 5))
 ;; ...more output omitted
```

## Author, License
Copyright (C) 2020 Alan Tseng

GNU Public License v3
