# Null, First e Follow sets

## **Problem**
Consider formal grammar G=(Σ,N,P,S) with possible *epsilon* productions.
Write a program that reads G and calculates the **NULL** predicate and sets of **FIRST** and **FOLLOWS** for the Non-terminals of the G grammar.
Consider a Non-terminal A and its productions A → α1 | . . . | αn

## **Input**
To simplify the format of the data input, we will admit here the Non-terminals are represented by names (string) beggining with captial letters and terminal symbols are constituted exclusively by lowercase letters.
In particular, the initial symbol will always be the Non-terminal 'S'. A production will always have the format 'N -> a' where 'a' is a non-empety sequence of symbols (terminal or Non-temrinal seperated by space).
In particular, the *epsilon* is represented by the character '_' (underscore).  
The format of the input data is then as follows.  
The first line contains an integer 'n' that indicates how many productions the grammar has.  
The remaining 'n' lines introduce grammar output (one per line).

## **Output**
Imagine that the input grammar has Non-temrinal symbols. The output is constitued for 3 x *m* lines.

As first *m* lines contain the information calculated for NULL in the format:

**NULL(X) = True**

or

**NULL(X) = False**

listed by alphabetical order of the Non-terminals X, with the exeption of the Non-terminal 'S' which is presented in the first position.
The next *m* lines contain the information calculated for the **FIRST** set in the format:
**FIRST(X) = a1 a2 a3 ... ap**
if, for the Non-terminal X, F IRST(X) = {a1 . . . ap}, ordered alphabetical order. The order of presentation followed by the Non-terminals is the same as that of the **FIRST**.
As the final *m* lines present the information calculated for the **FOLLOW** set in the same way as information for **FIRST** is presented. The particular case of the symbol '#' of FOLLOW(S) follows the rule of alphabetical order and is presented in the first position.

## **Example of input**
11  
S -> A  
S -> B D e  
A -> A e  
A -> e  
B -> d  
B -> C C  
C -> e C  
C -> e  
C -> _  
D -> a D  
D -> a  

## **Example of output**
NULL(S) = False   
NULL(A) = False  
NULL(B) = True  
NULL(C) = True  
NULL(D) = False  
FIRST(S) = a d e  
FIRST(A) = e  
FIRST(B) = d e  
FIRST(C) = e  
FIRST(D) = a  
FOLLOW(S) = #  
FOLLOW(A) = # e  
FOLLOW(B) = a  
FOLLOW(C) = a e  
FOLLOW(D) = e   
