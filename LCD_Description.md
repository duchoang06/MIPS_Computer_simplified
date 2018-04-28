This text describes how LCD would display. 

LCD 16x2 HD44780
Line 1: | P | C |: | <> | x | x | x | x | <> | x | x | x | x | <> | <> | <> |
Line 2:	| O | S |: | y | <> | O | V | : | z | z | z | z | z | z | z | z |

Note: xxxx_xxxx: current value of PC register (in base 16).
	  y (0 to 7): selected block whose value is to be displayed (in base 10) (input value is based on SW[17:10]).
	  zzzz_zzzz: output of selected block (in base 16).


