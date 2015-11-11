# String Change (Programming 70)

Description:
```
Use the programming interface to complete this task. Given an array of 5 numbers, change every nth character, with n being the value of the first number of the array and the first letter of the string as the 1st character, of a string and move its value up by one (a turns into b, z turns into a). Repeat this for the rest of the numbers of the array and return the changed string. Do this for all the strings. Be careful to keep the original capitalization!

For example: [2,3,7,5,4] and oTerNmIWxGqaaV would become oUftOoJYyIqdaX

ID: string-change
Input: Read the input from a file called string-change.in that contains a string of: a list of 5 numbers separated by commas followed by a linebreak, and then a string of random characters.
Output: The string changed according to the values in the list, written to a file called string-change.out.

You already know this, but don't forget to end your output with a newline.
```


```python
def shift(ch):
    num = ord(ch) + 1
    if (num > ord('z') and ch in "abcdefghijklmnopqrstuvwxyz") or (ch in "ABCDEFGHIJKLMNOPQRSTUVWXYZ" and num > ord('Z')):
        num -= 26
    return chr(num)

with open("string-change.in", "r") as f:
    inp = f.readlines()
    string = inp[1]
    ls = [int(x) for x in inp[0].split(",")]

string = list(string)
for i in ls:
    for x in range(1,len(string)//i if len(string) % i == 0 else len(string)//i + 1):
        if string[x*i].isalpha():
            string[x*i] = shift(string[x*i])

with open("string-change.out", "w") as f:
    f.write(''.join(string))
```

Flag: `easyctf{changing_things_up_once_in_a_while_is_gooood_for_you}`
