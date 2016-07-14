# Can you even (programming 40)

Description:
```
Use the programming interface to complete this task. You'll be given a list of numbers.

Input: A list of numbers, separated by commas.
Output: The number of even numbers.

Read the input from a file called can-you-even.in that's in the current working directory, and then write your output to a file called can-you-even.out.
```


```python
with open("can-you-even.in", "r") as f:
    inputs = [int(x) for x in f.read().split(',')]

with open("can-you-even.out", "w") as f:
    f.write(str(len([x for x in inputs if x % 2 == 0])) + "\n")
```

Flag: `easyctf{?v=8ruJBKFrRCk}`
