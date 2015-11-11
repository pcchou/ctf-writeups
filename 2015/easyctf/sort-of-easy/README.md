# Sorting-of Easy (programming 50)

Description:
```
Use the programming interface to complete this task.

Input: A list of numbers, separated by commas. Ex: 3,28,9,17,5
Output: The list sorted from largest to smallest, separated by commas. Ex: 28,17,9,5,3

Read the input from a file called sorting-job.in that's in the current working directory, and then write your output to a file called sorting-job.out.
```

```python
with open("sorting-job.in", "r") as f:
    rx = f.read().split(",")

output = [int(x) for x in rx]
output.sort()
output = [str(i) for i in sorted(output)[::-1]]

with open("sorting-job.out", "w") as f:
    f.write(",".join(output) + "\n")
```

Flag: `easyctf{sorting_is_as_easy_as_3_2_1!}`
