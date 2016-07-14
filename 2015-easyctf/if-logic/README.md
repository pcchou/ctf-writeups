# If logic (programming 30)

Description:
```
Use the programming interface to complete this task. You'll be given a list of numbers.

Input: A list of numbers, separated by commas.
Output: Print hi if the number is 0-50 (inclusive), hey if the number is 51-100 (inclusive), and hello if anything else. Each greeting should have a linebreak after it.

Read the input from a file called if-logic.in that's in the current working directory, and then write your output to a file called if-logic.out.
```

```python
with open("if-logic.in", "r") as f:
    inputs = [int(i) for i in f.read().split(",")]

output = ""

for i in inputs:
    if i <= 50:
        output += "hi\n"
    elif i <=100:
        output += "hey\n"
    else:
        output += "hello\n"

with open("if-logic.out", "w") as f:
    f.write(output)
```

Flag: `easyctf{is_it_hi_or_hey_or_something_else}`
