# Misc50 - Olive
``````
Description: Recover the flag from this session

Attachment: misc50.zip
``````

The attachment contained a pcapng packet dump file, which can be opened using wireshark.

At first glance, I saw there's some HTTP and QUIC requests to godaddy (some of them are OCSP) and  http://beford.org/, and some scattered DNS or NetBIOS requests.

35 seconds after the capture session started, the user initiated a VNC connection to 192.168.0.22 (with no auth), then there are some random pointer event through VNC.

![pointer event](http://i.imgur.com/A4ybu7A.png)

There's one interesting thing, after a few seconds of mouse clicking, then the user started to key in characters:

![key event](http://i.imgur.com/MTjkSh1.png)

So we can start to retrieve the keys the user entered.

First, I set the `vnc.key_down=="Yes"` wireshark filter as there will be two events (one key down, one key up) for each key presses, so only the VNC key event packets will be shown.

And the input is:

"notepad[Return]can you see me//[backspace*2][space][backspace][Return *n]"

Then it started to read the flag here:

![flag](http://i.imgur.com/oBRTd22.png)


Flag: EKO{NOT_anym0re_VNC_hax}
