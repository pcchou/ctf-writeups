# Sum it (programming 30)

Description: 
```
Use the programming interface to complete this task. You'll be given a list of numbers.

Input: A list of numbers, separated by commas.
Output: The sum of the numbers.

Read the input from a file called addition.in that's in the current working directory, and then write your output to a file called addition.out.
```

```python
with open("addition.in", "r") as f:
    list = [int(x) for x in f.read().split(",")]

with open("addition.out", "w") as f:
    f.write(str(sum(list)) + "\n")
```
Flag: `easyctf{'twas_sum_EZ_programming,_am_I_rite?}`
