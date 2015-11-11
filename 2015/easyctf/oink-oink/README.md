# Oink Oink (programming 115)

Description:
```
Use the programming interface to solve this problem.

Now that we know how to convert from English to Pig Latin, can we reverse the translation? Given a sentence in Pig Latin, reverse it and try to find the original English text.

Be careful to note that if a Pig Latin word is capitalized, like "Arispay", the original English word is "Paris" rather than "pAris". Case counts!

ID: piglatin2
Input: A sentence in Pig Latin.
Output: The translation in English.

Read the input from a file called piglatin2.in that's in the current working directory, and then write your output to a file called piglatin2.out
```

Another Pig Latin problem...

```python
def toEnglish(s):
    sentence = s.split(" ")
    english = ""
    for word in sentence:
        if word[:len(word) - 4:-1] == 'yay':
            english += word[:len(word) - 3] + " "
        else:
            noay = word[:len(word) - 2]
            english += noay[-1] + noay[:-1] + " "
            return english[:-1]

    with open("piglatin2.in", "r") as f:
        sentence = f.read()[:-1]
    with open("piglatin2.out", "w") as f:
        eng = toEnglish(sentence)
        f.write(eng.upper()[0] + eng.lower()[1:] + "\n")
    ```

Flag: `easyctf{th0se_pesky_capit4ls_were_a_pa1n,_weren't_they?}`
