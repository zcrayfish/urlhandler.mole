# urlhandler.mole
gopher mole for gophernicus to switch between hURL and type w depending on who's accessing a gopher menu

# How to use

You can either put the urlhandler script somewhere in the $PATH on your system, or put it in the root directory of your gopher server.

## In executable gophermaps

In a gophermap, replace any `GET /`, `hURL` or gophertype `w` entries with the the script (it's named urlhandler.sh here on github, but I personally use urlhandler.mole on my own boxen)

For example, on the root of my site, my IRC links look like this:

`urlhandler.mole irc://irc.libera.chat:6667/gopher "irc.libera.chat #gopher"`

`urlhandler.mole irc://irc.sdf.org:6667/gopher "irc.sdf.org #gopher"`

`urlhandler.mole ircs://irc.tilde.chat:6697/gopher "irc.tilde.chat #gopher"`

## In non-executable gophermaps

It can be called with gophernicus' `= subgophermap` directive... Here's an example in which the script is in the root directory of the gopher server, but being called from a directory two levels deep:

`=../../urlhandler.mole "https://en.wikipedia.org/wiki/Gopher_(protocol)" "https://en.wikipedia.org/wiki/Gopher_(protocol)"`

# Rationale

This is a hack I created because I cannot stand the [hURL scheme](http://gopher.quux.org:70/Archives/Mailing%20Lists/gopher/gopher.2002-02%7C/MBOX-MESSAGE/34) that was bafflingly created in 2002... This despite that gophertype `w` has been in libwww, and some other gopher clients, since at least 1992.
Unfortunately, some clients support one or the other, but none that I know of support both CORRECTLY. (invariably, clients I see that attempt to support both cannot load regular type `h` files on gopher, or have other severe issues, nearly always with hURL handling).

I will attempt to illustrate the three ways I can know of to link to an example website in gopher so that you may judge for yourself.

|type|display name   |selector                  |FQDN              |TCP port|
|----|---------------|--------------------------|------------------|--------|
|h   |Example website|GET /index.html           |www.example.org   |80      |
|h   |Example website|URL:http://www.example.org|gopher.example.org|70      |
|w   |Example website|http://www.example.org    |ANYTHING          |1       |

The issues:
* The `GET /` method **can only reliably link to HTML documents hosted by HTTP/0.9 servers**. Most HTTP servers I have run across these days upgrade all HTTP/0.9 requests to at least HTTP/1.0, which adds garbage headers to anything sent back... Gopher-only or HTTP/0.9 clients *might* be able to receive HTML documents from these servers, but could complain about the headers, and text-documents would be even worse... Binary files flat-out will not work for the HTTP/0.9 or gopher clients using this method with HTTP/1.0+ servers.
  * Some clients that support HTTP/1.0 and higher are still restricted to HTML documents using the `GET /` hack. Lynx is one such client.
  * The HTTP/0.9 specification also clearly says that it is to transfer HTML only, using it for binaries is out of scope.
  * **This method has been [obsolete since 1992](https://math.albany.edu/g/Adm/goph-www.html#1.2), for the love of god don't use it!**
* The type `h` with selector beginning with `URL:` method (referred to as `hURL` henceforth)
  * Requires the server to actually support it, which some don't.
    * Some servers, such as gophernicus, restrict what types of URLs can be linked to
  * _should_ only be used to link to HTML files
    * But most HTML capable clients can handle other really basic files, such as plain text, JPEGs, or GIFs.
* Type `w`
  * Much simpler than the other two types because the client need only deal with the `type`, `display name` and `selector fields`. (the `FQDN` and `PORT` fields are not used at all for this type)
  * Can link to any valid URL, the client is simply expected to open whatever the default application is for the given URI scheme.
  * Has been around as far back as I am able to browse the libwww source, 1992 or before, which made the `hURL` hack absolutely pointless.
  * Only requires client support, but some clients might not support it due to it not being in the gopher RFC, more of a problem with NEWER clients due to the `hURL` distraction
    * Many libwww-based clients do support it however. (e.g. Lynx, elinks)
    * Now also supported by the popular Squid proxy/cache server.
