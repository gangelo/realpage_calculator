Questions

let Terminator = "q or end of input indicator (EOF / Ctrl+D)"

Q. Regarding a Terminator...
   Am I to assume that a Terminator appear anywhere within a series of tokens or am I to assume a Terminator must appear as a stand-alone token?
   For example, are these okay or considered an input error?
   > 2 1 - q
   > 2 1 q +


Q. I am going to ignore anything following a Terminator unless you tell me otherwise; is this acceptable?



Would've liked to...
Make operators configurable using a config class
Localize error messages
Document the code using rdoc

TODO: 

CalculatorService should accept input_stack as a param to #initialize so that it's state can be restored between http or socket calls.