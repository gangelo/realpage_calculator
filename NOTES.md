TODO: 

CalculatorService should accept input_stack as a param to #initialize so that it's state can be restored between http or socket calls.


In highsight, I probably should have moved the convenience extensions somewhere else to avoid potential collisions with extensions in the consuming application.
Put this code in a Ruby gem. 

Eliminate hard-coding the names of the yaml config files in /calculator/config?