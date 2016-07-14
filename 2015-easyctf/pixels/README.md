# Pixels (forensics 180)

Descriptions:
```
Solved by 315 teams.
mystery1 - mystery2

Hint: Did you know you can do math on images?
```

We immediately know that it is probably image XOR, so I opened the file with `stegsolve.jar`:

![stegsolve](http://i.imgur.com/ZLQ3P0W.png)

Combine the images:

![xor](http://i.imgur.com/ZLQ3P0W.png)

Then the flag appeared.

Flag: `easyctf{pretty_pixel_math}`
