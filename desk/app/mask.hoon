::  %mask - by deathtothecorporation
::
/-  *mask
/+  verb, dbug, default-agent, http=mask-http, etch
::
|%
::
+$  versioned-state  $%(state-0)
::
+$  state-0
  $:  %0
      caches=(set secret)
      recent=(list logins)
      failed=(list logins)
      banned=(set ip)
  ==
::
::  boilerplate
::
+$  card  card:agent:gall
--
::
%+  verb  &
%-  agent:dbug
=|  state-0
=*  state  -
::
^-  agent:gall
::
=<
  |_  =bowl:gall
  +*  this  .
      def  ~(. (default-agent this %|) bowl)
      eng   ~(. +> [bowl ~])
  ++  on-init
    ^-  (quip card _this)
    =^  cards  state  abet:init:eng
    [cards this]
  ::
  ++  on-save
    ^-  vase
    !>(state)
  ::
  ++  on-load
    |=  ole=vase
    ^-  (quip card _this)
    =^  cards  state  abet:(load:eng ole)
    [cards this]
  ::
  ++  on-poke
    |=  cag=cage
    ^-  (quip card _this)
    =^  cards  state  abet:(poke:eng cag)
    [cards this]
  ::
  ++  on-arvo
    |=  [wir=wire sig=sign-arvo]
    ^-  (quip card _this)
    =^  cards  state  abet:(arvo:eng wir sig)
    [cards this]
  ::
  ++  on-peek
    |=  pat=path
    ^-  (unit (unit cage))
    (peek:eng pat)
  ::
  ++  on-agent
    |=  [wir=wire sig=sign:agent:gall]
    ^-  (quip card _this)
    `this
  ::
  ++  on-watch
    |=  pat=path
    ^-  (quip card _this)
    =^  cards  state  abet:(peer:eng pat)
    [cards this]
  ::
  ++  on-fail
    on-fail:def
  ::
  ++  on-leave
    on-leave:def
  --
|_  [bol=bowl:gall dek=(list card)]
+*  dat  .
    our  (scot %p our.bol)
    now  (scot %da now.bol)
    paz  /(scot %p our.bol)/azimuth/(scot %da now.bol)
++  emit  |=(=card dat(dek [card dek]))
++  emil  |=(lac=(list card) dat(dek (welp lac dek)))
++  abet  ^-((quip card _state) [(flop dek) state])
++  show  |=(cag=cage (emit %give %fact [/web-ui]~ cag))
::
++  wisp
  ^-  [secret _dat]
  =+  new=(sham [eny now]:bol)
  =+  pat=/behn/(scot %uv new)
  :-  new
  %-  emit(caches (~(put in caches) new))
  [%pass pat %arvo %b %wait (add now.bol ~m5)]
::
++  next
  |=  how=$@(%local ip)
  ^+  dat
  =?    recent
      (gth (lent recent) 25)
    (snip recent)
  dat(recent [[how now.bol] recent])
::
++  init
  ^+  dat
  (emit %pass /init %arvo %b %wait now.bol)
::
++  load
  |=  vaz=vase
  ^+  dat
  ?>  ?=([%0 *] q.vaz)
  dat(state !<(state-0 vaz))
::
++  peek
  |=  pol=(pole knot)
  ^-  (unit (unit cage))
  ?+    pol  !!
      [%x %caches ~]
    ``mask-caches+!>(caches)
      [%x %banned ~]
    ``mask-banned+!>(banned)
      [%x %failed ~]
    ``mask-failed+!>(failed)
      [%x %recent ~]
    ``mask-recent+!>(recent)
  ==
::
++  peer
  |=  pol=(pole knot)
  ^+  dat
  ?+    pol  !!
    [%http-response *]  dat
  ::
      [%web-ui ~]
    =~  (show mask-caches+!>(caches))
        (show mask-banned+!>(banned))
        (show mask-failed+!>(failed))
        (show mask-recent+!>(recent))
    ==
  ==
::
++  arvo
  |=  [pol=(pole knot) sig=sign-arvo]
  ?+    pol  ~|(mask-bad-arvo/[pol sig] !!)
      [%eyre ~]
    ~_  'mask-panic: failure to bind upload.'
    ?>  ?=([%eyre %bound %& *] sig)
    dat
  ::
      [%init ~]
    ~_  'mask-panic: failure to behn timer.'
    ?>  ?=([%behn %wake *] sig)
    %-  emil
    :~
      =-  [%pass /eyre %arvo %e %connect -]
      [[~ [%apps %mask %code ~]] dap.bol]
      =-  [%pass /eyre %arvo %e %connect -]
      [[~ [%apps %mask %login ~]] dap.bol]
    ==
  ::
      [%iris eid=@ ~]
    ~_  'mask-panic: cookie jar broken.'
    ?.  ?=([%iris %http-response %finished *] sig)  dat
    =/  pay=simple-payload:^http  [+>+<.sig ~]
    =/  headers=(map @t @t)  (malt ;;((list [@t @t]) headers.response-header.pay))
    =/  new=simple-payload:^http
      =-  (json-response:gen:serve -)
      ?~  cookie=(~(get by headers) 'set-cookie')  !!
      (en-vase:etch !>(`@t`u.cookie))
    %-  emil  %-  flop
    (give-simple-payload:app:serve eid.pol new)
  ::
      [%behn cod=@ ~]
    =+  cod=(slav %uv cod.pol)
    ?>  ?=([%behn %wake *] sig)
    %.  %.  mask-action+!>(`actions`clear+[%cache `cod])
        show(caches (~(del in caches) cod))
    ?~  error.sig  (slog 'mask-timer-elapse' ~)
    (slog 'mask-panic-timer-fail' u.error.sig)
  ==
::
++  poke
  |=  [mar=mark vaz=vase]
  ^+  dat
  ?+    mar  ~|(mask-bad-poke/[mar vaz] !!)
    :: XX: remove
    ::   %noun
    :: =;  [req=request:^http out=outbound-config:iris]
    ::   (emit %pass /iris/test %arvo %i %request req out)
    :: :_  *outbound-config:iris
    :: =,  mimes:html
    :: :^    %'POST'
    ::     'http://localhost:8080/~/login'
    ::   ['Content-Type'^'application/x-www-form-urlencoded']~
    :: `(as-octt (welp "password=" get-code:cryp))
  ::
      %mask-action
    ?>  =(our.bol src.bol)
    =+  act=!<(actions vaz)
    ?-    -.act
        %clear
      ?-    -.type.act
          %cache
        ?~  p.type.act
          (show(caches ~) mask-action+!>(`actions`act))
        %.  mask-action+!>(`actions`act)
        show(caches (~(del in caches) u.p.type.act))
      ::
          %fresh
        ?~  p.type.act
          (show(recent ~) mask-action+!>(`actions`act))
        =.  recent
          (flop (oust [0 u.p.type.act] (flop recent)))
        (show mask-action+!>(`actions`act))
      ::
          %fails
        ?~  p.type.act
          (show(failed ~) mask-action+!>(`actions`act))
        =.  failed
          (flop (oust [0 u.p.type.act] (flop failed)))
        (show mask-action+!>(`actions`act))
      ==
    ::
        %punish
      %.  mask-action+!>(`actions`act)
      show(banned (~(put in banned) ip.act))
    ::
        %pardon
      %.  mask-action+!>(`actions`act)
      show(banned (~(del in banned) ip.act))
    ::
        %secret
      =^  clue  dat  wisp
      =+  date=mask-update+!>(`updates`a-secret+clue)
      %.  (show:(show mask-action+!>(`actions`act)) date)
      (slog ~[(cat 3 'mask-secret: ' (scot %uv clue))])
    ::
        %answer
      =*  fail
        =+  mass=mask-action+!>(`actions`act)
        =/  date=cage
          :-  %mask-update
          !>(result+[now.bol sec.act %local %n])
        =.  caches  (~(del in caches) sec.act)
        (show:(show mass) date)
      ?.  (~(has in caches) sec.act)  fail
      ?~  test=(validate:cryp [sec ady sig]:act)  fail
      ?-    u.test
        %|  ((slog 'mask-failed-answer' ~) fail)
      ::
          %&
        =.  caches  (~(del in caches) sec.act)
        =-  ((slog (crip get-code:cryp) ~) -)
        %.  mask-update+!>(result+[now.bol sec.act %local %.y])
        show:(show:(next %local) mask-action+!>(`actions`act))
      ==
    ==
  ::
      %handle-http-request
    =+  !<([id=@ta req=inbound-request:eyre] vaz)
    =^  clue  dat  wisp
    =/  hp
      =~  %-  hp-abed:http
          [bol id req clue caches recent failed banned]
          hp-hand
      ==
    =+  hp-abut:hp
    (emil(recent rec, failed fel, banned bad) (flop hp-abet:hp))
  ==
++  cryp
  |%
  ++  who-am-i
    ^-  (unit @ux)
    =-  ?~  pin=`(unit point:nav)`-
          ~
        ?.  |(?=(%l1 dominion.u.pin) ?=(%l2 dominion.u.pin))
          ~
        `address.owner.own.u.pin
    .^  (unit point:nav)
      %gx
      (welp paz /point/[our]/noun)
    ==
  ++  challenge  ^-(secret (sham [now eny]:bol))
  ++  from-tape
    |=(h=tape ^-(@ux (scan h ;~(pfix (jest '0x') hex))))
  ++  get-code
    (slag 1 (scow %p .^(@p %j /[our]/code/[now]/[our])))
  ++  validate
    |=  [challenge=secret address=tape hancock=tape]
    ^-  (unit ?)
    =+  addy=(from-tape address)
    =+  cock=(from-tape hancock)
    =+  whom=who-am-i
    ?~  whom
      `?:(.^(? %j /[our]/fake/[now]) %& %|)
    ?.  =(addy u.whom)  ~
    ?.  (~(has in caches) challenge)  ~
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
    =+  add=(address-from-pub:key:eths pub)
    `=(addy add)
  --
--
