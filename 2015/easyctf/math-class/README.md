# Math Class (Programming 50)

Description:
```
Use the programming interface to complete this task. You'll be given a math expression, such as add 1 2 or subtract 5 3, where you will perform the operations 1+2 and 5-3, respectively.

ID: math-class
Input: An expression in the form of operation operand1 operand2, separated by spaces. Read input from math-class.in.
Output: The absolute value of the evaluated expression. Your output should always be a positive integer.

There are only 2 different possible operations, addition and subtraction, and all operands will be integer values between 1 and 1000. As always, remember to end your program with a newline.
```

```python
with open("math-class.in", 'r') as f:
    rx = f.readlines()

tx = ""

for line in rx:
    ll = line.split(' ')
    if ll[0] == "add":
        tx = tx + str(int(ll[1]) + int(ll[2])) + "\n"
    elif ll[0] == "subtract":
        tx = tx + str(abs(int(ll[1]) - int(ll[2]))) + "\n"

with open("math-class.out", "w") as f:
    f.write(tx)
```

Flag: `easyctf{have_y0u_had_enough_of_math_in_sk0ol_yet}`
