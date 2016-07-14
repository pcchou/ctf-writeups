# Sayonara (Forensics 325)

Description:
```
Found some interesting words of advice left by sayonara-bye... help me understand it!

sayonara.mp3 MD5: 9f44501f0ac360c3255548c96b70aecb

Hint: Why does that right channel sound strange?
```

The mp3 file is a 45 sec stereo audio.

![stereo](http://i.imgur.com/qPzh1NQ.png)

The hint mentioned something about the right channel, then after some investigation, I checked its spectrogram.

![spectrogram](http://i.imgur.com/dzzSbf5.png)

There must be something hiding in it.

After some enhancement:

![flag](http://i.imgur.com/hvIkAOr.png)

Then we can see the flag.

Flag: `easyctf{do_a_frustration}`
