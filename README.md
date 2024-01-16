# Hash
Assembly and Python code of a Hash function
AUTHOR:
Za0Warudo, Vinicius Gomes

EMAIL:
viniciusgomes24@usp.br 

HOW TO EXECUTE:
use the makefile given with the implementation, and in a terminal use the following command line: 

./hash 

to execute the assembly code 
and the following to execute the python code 

python3 hash.py 

to execute the test use: 

./test.sh hash <file>  

TEST:

-INPUT-  
test.sh hash texto10.txt 

-OUTPUT- 
Python:
7ea2319be0d038908161b4e8c26bfc7a
.079088492
Assembly:
7ea2319be0d038908161b4e8c26bfc7a
.005883464

-INPUT-  
test.sh hash texto100.txt 

-OUTPUT-
Python:
9e871c16cdf245202e8d17c05a4dd7f
.084666531
Assembly:
9e871c16cdf245202e8d17c05a04dd7f
.005871861

-INPUT-
test.sh hash texto1000.txt 

-OUTPUT- 
Python:
e29bc29fa4763defde799aa6a8995f19
.100732696
Assembly:
e29bc29fa4763defde799aa6a8995f19
.006158993

-INPUT- 
test.sh hash texto10000.txt 

-OUTPUT- 
Python:
b8ac6e63be8116b5bdf97ea3832b7e1a
.291347061
Assembly:
b8ac6e63be8116b5bdf97ea3832b7e1a
.010364614

DEPENDENCIES: 
all test was made only in a machine with the following versions:  
Ubuntu 22.04.3 LTS 
NASM version 2.16.01
GNU ld (GNU Binutils for Ubuntu) 2.38
