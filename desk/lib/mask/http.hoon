::  /lib/mask/http/hoon
::
::  TODO: make cryp a library
/-  m=mask
/+  multi=multipart
|_  $:  bol=bowl:gall
        eid=@ta
        sec=@uv
        caz=(list card:agent:gall)
        inb=inbound-request:eyre
        pay=(unit simple-payload:http)
        cac=(set secret:m)                              ::  caches set
        rec=(list logins:m)                             ::  logins list
        fel=(list logins:m)                             ::  failed ips
        bad=(set ip:m)                                  ::  banned ips
    ==
+*  hp  .
    our  (scot %p our.bol)
    now  (scot %da now.bol)
    paz  /(scot %p our.bol)/azimuth/(scot %da now.bol)
    card  card:agent:gall
++  hp-emit  |=(c=card hp(caz [c caz]))
++  hp-emil  |=(lac=(list card) hp(caz (welp lac caz)))
++  hp-show  |=(cag=cage (hp-emit %give %fact [/web-ui]~ cag))
++  hp-fail
  =/  index=(unit simple-payload:http)
  ~&  "hp fail "
    =/  tube
      .^(tube:clay %cc /[our]/mask/[now]/html/mime)
    =/  file
      .^(@t %cx /[our]/mask/[now]/app/mask/index/html)
    :+  ~  400^['content-type' 'text/html']~
    =-(`q !<(mime (tube !>(`@t`file))))
  =.  sec  0v0
  hp(pay index)
++  hp-abet
  ^-  (list card)
  ?~  pay  (flop caz)
  %-  welp  :_  (flop caz)
  (give-simple-payload:app:serve:m eid (need pay))
++  hp-abut
  [cac=cac rec=rec fel=fel bad=bad]
++  hp-abed
  |=  $:  o=bowl:gall
          e=@ta
          i=inbound-request:eyre
          s=@uv
          c=(set secret:m)
          r=(list logins:m)
          f=(list logins:m)
          b=(set ip:m)
      ==
  hp(bol o, eid e, inb i, cac c, sec s, rec r, fel f, bad b)
++  hp-next
  |=  how=$@(%local ip:m)
  ^+  hp
  =?    rec
      (gth (lent rec) 25)
    (snip rec)
  hp(rec [[how now.bol] rec])
++  hp-part
  |%
  ++  en  (corl (cury rsh [3 1]) spat)
  ++  dir  /[our]/mask/[now]
  ++  index
    ^-  (unit simple-payload:http)
    =/  tube
      .^(tube:clay %cc (welp dir /html/mime))
    =/  file
      .^(@t %cx (welp dir /app/mask/index/html))
    =+  !<(mime (tube !>(file)))
    `[200^['content-type' (en p)]~ `q]
  ++  style
    ^-  (unit simple-payload:http)
    =/  tube
      .^(tube:clay %cc (welp dir /css/mime))
    =/  file
      .^(@t %cx (welp dir /app/mask/assets/style/css))
    =+  !<(mime (tube !>(file)))
    `[200^['content-type' (en p)]~ `q]
  ++  javas
    ^-  (unit simple-payload:http)
    =/  tube
      .^(tube:clay %cc (welp dir /js/mime))
    =/  file
      .^(@t %cx (welp dir /app/mask/assets/index/js))
    =+  !<(mime (tube !>(file)))
    `[200^['content-type' (en p)]~ `q]
  ++  image
    ^-  (unit simple-payload:http)
    =/  tube
      .^(tube:clay %cc (welp dir /svg/mime))
    =/  file
      .^(@t %cx (welp dir /app/mask/assets/terminal-big/svg))
    =+  !<(mime (tube !>(file)))
    `[200^['content-type' (en p)]~ `q]
  --
++  hp-hand
  ^+  hp
  =*  headers  header-list.request.inb
  =+  source=(~(got by (malt headers)) 'host')
  =+  reqline=(parse-request-line:serve:m url.request.inb)
  =+  url=`(pole knot)`site.reqline
  ~&  'hp-hand'
  ~&  url
  ?:  ?=([%apps %mask %code ~] url)
      ?:  authenticated.inb  hp-code
      hp(pay index:hp-part)
  ?>  ?=([%apps %mask %login rest=*] url)
  ?+    method.request.inb  hp(pay `[405^~ ~])
      %'GET'
    ?+    rest.url  !!
      ~                hp(pay index:hp-part)
      [%$ ~]           hp(pay index:hp-part)
      [%constants ~]   hp(pay hp-json)
    ::
        [%assets wic=@ res=*]
      ?+  wic.rest.url  !!
        %index         hp(pay javas:hp-part)
        %style         hp(pay style:hp-part)
        %terminal-big  hp(pay image:hp-part)
      ==
    ==
  ::
      %'POST'
    ?>  ?=([%submit ~] rest.url)
    ?:  (~(has in bad) address.inb)
      hp(pay `[405^~ ~])
    =/  hmap  (malt headers)
    ?~  typ=(~(get by hmap) 'content-type')  hp-fail
    ?.  =('application/json' u.typ)  hp-fail
    ?~  org=(~(get by hmap) 'origin')  hp-fail
    ?~  jon=(de:json:html q:(need body.request.inb))  hp-fail
    ?.  ?=([%o *] u.jon)  hp-fail
    ?~  msg=(~(get by p.u.jon) 'message')  hp-fail
    ?~  ady=(~(get by p.u.jon) 'eth-address')  hp-fail
    ?~  sig=(~(get by p.u.jon) 'signature')  hp-fail
    =+  mes=`@uv`(slav %uv ?>(?=([%s @] u.msg) p.u.msg))
    =+  dre=`tape`(trip ?>(?=([%s @] u.ady) p.u.ady))
    =+  cok=`tape`(trip ?>(?=([%s @] u.sig) p.u.sig))
    =/  failure
      =.  cac  (~(del in cac) mes)
      (hp-show mask-update+!>(result+[mes dre cok]))
    ?.  (~(has in cac) mes)  hp-fail:failure
    ?~  czek=(validate:hp-cryp mes dre cok)
      hp-fail:failure
    ?-    u.czek
        %|
      %=  failure
        pay  `[405^~ ~]
        cac  (~(del in cac) mes)
      ::
          fel
        =?    fel
            (gth (lent fel) 25)
          (snip fel)
        [[address.inb now.bol] fel]
      ==
    ::
        %&
      ::  generate cookie, return to fe
      ~&  "here!"
      =;  [req=request:http out=outbound-config:iris]
        (hp-emit %pass /iris/[eid] %arvo %i %request req out)
      :_  *outbound-config:iris
      =,  mimes:html
      :^    %'POST'
          (crip (weld (trip u.org) "/~/login"))
        ['Content-Type'^'application/x-www-form-urlencoded']~
      `(as-octt (welp "password=" get-code:hp-cryp))
    ==
  ==
++  hp-cryp
  |%
  ++  who-am-i
    ^-  (unit @ux)
    =-  ?~  pin=`(unit point:nav:m)`-
          ~
        ?.  |(?=(%l1 dominion.u.pin) ?=(%l2 dominion.u.pin))
          ~
        `address.owner.own.u.pin
    .^  (unit point:nav:m)
      %gx
      (welp paz /point/[our]/noun)
    ==
  ++  from-tape
    |=(h=tape ^-(@ux (scan h ;~(pfix (jest '0x') hex))))
  ++  get-code
    (slag 1 (scow %p .^(@p %j /[our]/code/[now]/[our])))
  ++  validate
    |=  [challenge=secret:m address=tape hancock=tape]
    ^-  (unit ?)
    =+  addy=(from-tape address)
    =+  cock=(from-tape hancock)
    =+  whom=who-am-i
    ?~  whom
      `?:(.^(? %j /[our]/fake/[now]) %& %|)
    ?.  =(addy u.whom)  ~
    ?.  (~(has in cac) challenge)  ~
    =/  note=@uvI
      =+  octs=(as-octs:mimes:html (scot %uv challenge))
      %-  keccak-256:keccak:crypto
      %-  as-octs:mimes:html
      ;:  (cury cat 3)
        '\19Ethereum Signed Message:\0a'
        (crip (a-co:co p.octs))
        q.octs
      ==
    ?.  &(=(20 (met 3 addy)) =(65 (met 3 cock)))  ~
    =+  r=(cut 3 [33 32] cock)
    =+  s=(cut 3 [1 32] cock)
    =/  v=@
      =+  v=(cut 3 [0 1] cock)
      ?+  v  !!
        %0   0
        %1   1
        %27  0
        %28  1
      ==
    ?.  |(=(0 v) =(1 v))  ~
    =/  xy
      (ecdsa-raw-recover:secp256k1:secp:crypto note v r s)
    =+  pub=:((cury cat 3) y.xy x.xy 0x4)
    =+  add=(address-from-pub:key:eths:m pub)
    `=(addy add)
  --
++  hp-json
  ^-  (unit simple-payload:http)
  =+  our=(crip (slag 1 (scow %p our.bol)))
  =+  msg=(scot %uv sec)
  =/  ady=cord
    =+  pin=who-am-i:hp-cryp
    %-  crip
    ['0x' ((x-co:co 32) ?~(pin 0x0 u.pin))]
  =-  `[200^['content-type' 'application/json']~ `-]
  %-  as-octt:mimes:html
  %-  trip
  %-  en:json:html
  %-  pairs:enjs:format
  :~  'SHIP_NAME'^s/our
      'ETH_ADDRESS'^s/ady
      'CHALLENGE'^s/msg
  ==
++  hp-code
  ^+  hp
  =/  head=(list (pair @t @t))
    ['content-type' 'application/json']~
  =;  code=octs
    %=  hp
      pay  `[200^head `code]
      rec  rec:(hp-next address.inb)
      cac  (~(del in cac) mes)
    ==
  %-  as-octt:mimes:html
  %-  trip
  %-  en:json:html
  %-  frond:enjs:format
  luscode+s/(crip get-code:hp-cryp)
--
