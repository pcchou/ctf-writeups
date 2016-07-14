# LLARGE (misc 50)

Description:
```Snoopy got the other LARGE [thing](https://www.dropbox.com/s/0xzmgl8rhpv9g1d/flag.png).
It is more difficult for you to decode it.
```

給的檔案 (`flag.png`) 是一個裡面是 QR Code 的 PNG 圖片。直接使用一般的 QR Code Reader 解出來則是 `PK`。

看到這裡，李組長眉頭一皺，發現事情並不單純，怎麼可能這樣解出來只有兩個 byte 呢XD

我們就丟給 [ZXing](https://zxing.org/w/decode) 解解看吧～

解出來的 Raw bytes:
```
40 0e d5 04 b0 30 41 40   00 20 00 80 01 d3 49 c4
79 b2 b5 7d f4 70 00 00   04 80 00 00 00 80 01 c0
06 66 c6 16 72 e7 47 87   45 55 40 90 00 31 96 78
05 61 96 78 05 67 57 80   b0 00 10 4f 50 10 00 00
41 40 00 00 0f 34 82 d4   a5 52 f5 64 8c b4 94 cb
75 27 00 e7 1a b0 ec 94   88 d4 fc ac c4 b2 ca a8
cc fc 84 c4 98 dc fc c8   b0 f0 c8 a4 fc e4 f4 95
58 cf 20 c8 8f 7f 40 37   21 53 d4 bd 48 be 31 37
31 3a b3 2f 3d 21 56 bb   98 00 00 05 04 b0 10 21
e0 31 40 00 20 00 80 01   d3 49 c4 79 b2 b5 7d f4
70 00 00 04 80 00 00 00   80 01 80 00 00 00 00 00
10 00 00 0a 48 10 00 00   00 06 66 c6 16 72 e7 47
87 45 55 40 50 00 31 96   78 05 67 57 80 b0 00 10
4f 50 10 00 00 41 40 00   00 05 04 b0 50 60 00 00
00 00 10 00 10 04 e0 00   00 08 90 00 00 00 00 00
ec 11 ec 11 ec 11 ec 11   ec 11 ec 11 ec 11 ec 11
ec 11 ec 11 ec 11 ec 11   ec 11 ec 11 ec 11 ec 11
ec 11
```

雖然 byte 組被拆開了，不過眼尖的大家可以看到 `5 0|4 b|0 3|0 4` 這些敏感文字，這就是 PkZip （也就是 `.zip` 壓縮檔）格式的表頭啊！

讓我們把它解開吧！

因為兩組 byte 讓 `50|4b` 被拆開了的關係，所以我們再前面補一個 byte 讓它在正確的位置。<br>
（我在前面加了一個 "a"）

```
$ echo $(echo "a" && cat decode) | tr -d " " | xxd -r -p > flag.zip # 讀取 decode 檔案，前面加上 "a" | 去掉空白 | 把 plain hexdump 轉換成 binary > 存到 flag.zip
$ unzip flag.zip # 解壓縮
Archive:  flag.zip
warning [flag.zip]:  3 extra bytes at beginning or within zipfile
  (attempting to process anyway)
inflating: flag.txt
$ cat flag.txt # 讀出 flag.txt
Here's flag: CTF{The_binary_hide_in_QR_code!ZIP_IN_QR!It's_amazing!}



```

Flag: `CTF{The_binary_hide_in_QR_code!ZIP_IN_QR!It's_amazing!}`
