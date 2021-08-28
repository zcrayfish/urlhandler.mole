#! /bin/ash

#Lets assume that 127.0.0.1 is either a local lynx or lynx as our web
#frontend (screen scraper), in which case a URL should be served as
#gophertype w, which is only supported by lynx that I know of
URL="$1"
shift
TEXT=$*
if test "$REMOTE_ADDR" = "127.0.0.1"; then
  echo -e "w$TEXT\\t$URL\\t(NULL)\\t1"
  exit
fi

if test "$SVCNAME" = "stunnel"; then
  echo -e "w$TEXT\\t$URL\\t(NULL)\\t1"
  exit
fi


if test "$REMOTE_ADDR" = "45.79.25.112"; then
  echo -e "w$TEXT\\t$URL\\t(NULL)\\t1"
  exit
fi

#Otherwise send them an hURL; at least gophernicus can serve an HTML
#page with a meta redirect, which is really fucking stupid.
echo -e "h$TEXT\\tURL:$URL\\t$SERVER_HOST\\t$SERVER_PORT"
