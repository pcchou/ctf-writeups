# Hijacked (Linux 100)

Description:
```
Someone planted a file on our computer (the shell server), but we don't know what it is! The only clue that we have is that it's owned by a user called l33t_haxx0r. Can you figure out the flag?

Hint: Try to look up useful Linux commands.
```

We'll need to find any files that's owned by `l33t_haxx0r`.

```shell
$ find / -user l33t_haxx0r 2>/dev/null
/var/www/html/index.html
```

Then just `less` the file, and at line 221 you can find the flag:

![flag!](http://i.imgur.com/P6MylmD.png)

Flag: `easyctf{c0mp1et3ly_r3kt}`
