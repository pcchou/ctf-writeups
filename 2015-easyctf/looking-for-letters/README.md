# Looking for letters (Programming 65)

Description:
```
Use the programming interface to complete this task.

Input: A string containing alphanumeric characters.
Output: A string containing only the letters of the input.

Read the input from a file called looking-for-letters.in that's in the current working directory, and then write your output to a file called looking-for-letters.out.
```

```python
with open("looking-for-letters.in", "r") as f:
    str = f.read()

with open("looking-for-letters.out", "w") as f:
    f.write(''.join([x for x in list(str) if x.isalpha()]) + "\n")
```

Flag: `easyctf{filtering_the_#s_out}`
