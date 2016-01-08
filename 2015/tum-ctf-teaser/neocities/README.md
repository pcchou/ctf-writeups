# neocities (web 50)

```
Description: So I hope you're well insured, because the nineties have sent us their
best thing ever: bright colors and Comic Sans MS. Please end it before
everyone dies due to internal bleedings.

1.ctf.link:1123
```

Browsing the URL provided, there's a ugly web site with a terrible colorscheme and Comic Sans MS.

![ugly site](http://i.imgur.com/8T8N8Vv.png)

We know that it's a apache2 on debian setup by the 404 page.

![404](http://i.imgur.com/GZeAGsz.png)

The `index.php` display a page according to the get parameter `page`, and it's not filtered in any way, so it's a LFI vuln.

![LFI](http://i.imgur.com/v9G3N7G.png)

After a few tries, we can find the path to `/`.

![/etc/passwd](http://i.imgur.com/EpAjpUs.png)

Then I noticed a strange thing at the end of `../../../../etc/apache2/sites-enabled/000-default.conf`.<br>
(The location of debian\'s default apache2 virtual host configuration)

```
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf

        RedirectMatch 403 flag.txt
</VirtualHost>
```

The flag is at `http://1.ctf.link:1123/index.php\?page\=flag.txt`.

![flag](http://i.imgur.com/A9k7qvT.png)

Flag: hxp{the_nineties_called_they_want_their_design_back}

P.S. Thanks my teammate at Come to Try Fortune [@seadog007](http://seadog007.me/) for this! Most of it is solved by him :stuck_out_tongue:
