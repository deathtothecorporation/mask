/-  m=mask
|%
++  enjs
  =,  enjs:format
  |%
  ++  secret   |=(s=@uv s/(scot %uv s))
  ++  address  |=(a=@ux s/(crip ['0x' ((x-co:co 32) a)]))
  ++  login    |=(log=login:m ?@(log s/'LOCAL' (ip-addy log)))
  ++  logins
    |=  logs=logins:m
    (pairs login+(login p.logs) timestamp+(sect q.logs) ~)
  ++  pack
    |=  [typ=@t faz=@t pay=json]
    (pairs type+s/typ face+s/faz fact+pay ~)
  ++  ip-addy
    |=  =ip:m
    ^-  json
    %+  frond  %ip-address
    ?-  -.ip
        %ipv4
      (pairs protocol+s/'ipv4' address+s/(scot %if +.ip) ~)
    ::
        %ipv6
      (pairs protocol+s/'ipv6' address+s/(scot %is +.ip) ~)
    ==
  ++  caches
    |=  cac=(set secret:m)
    ^-  json
    (pack 'SCRY' 'CACHES-LOAD' a/(turn ~(tap in cac) secret))
  ++  recent
    |=  rec=(list logins:m)
    ^-  json
    (pack 'SCRY' 'RECENT-LOAD' a/(turn rec logins))
  ++  failed
    |=  fal=(list logins:m)
    ^-  json
    (pack 'SCRY' 'FAILED-LOAD' a/(turn fal logins))
  ++  banned
    |=  ban=(set ip:m)
    ^-  json
    (pack 'SCRY' 'BANNED-LOAD' a/(turn ~(tap in ban) ip-addy))
  ++  updates
    |=  upd=updates:m
    ^-  json
    ?-    -.upd
        %a-secret
      %^  pack  'FACT'
        'CACHES-NEW-SECRET'
      (frond new-secret+s/(scot %uv sec.upd))
    ::
        %a-result
      %^  pack  'FACT'
        'CACHES-ANSWER-RESULT'
      %-  pairs
      :~  attempt-date+(sect wen.upd)
          secret-used+(secret sec.upd)
          login-method+(login way.upd)
      ==
    ==
  ++  actions
    |=  act=actions:m
    ^-  json
    ?-    -.act
        %clear
      ?-    -.type.act
          %cache
        %^  pack  'FACT'
          'CACHES-CLEAR'
        ?~(p.type.act s/'ALL' s/(scot %uv u.p.type.act))
      ::
          %fresh
        %^  pack  'FACT'
          'RECENT-CLEAR'
        ?~(p.type.act s/'ALL' (frond number+(numb u.p.type.act)))
      ::
          %fails
        %^  pack  'FACT'
          'FAILED-CLEAR'
        ?~(p.type.act s/'ALL' (frond number+(numb u.p.type.act)))
      ==
    ::
        %secret
      (pack 'FACT' 'CACHES-ADD-SECRET' s/'AWAIT-UPDATE')
    ::
        %answer
      %^  pack  'FACT'
        'CACHES-ANSWER-SUBMITTED'
      %-  pairs
      :~  secret+(secret sec.act)
          address+s/(crip ady.act)
          signature+s/(crip sig.act)
      ==
    ::
        %punish
      (pack 'FACT' 'BANNED-BAN-IP' (ip-addy ip.act))
    ::
        %pardon
      (pack 'FACT' 'BANNED-UNBAN-IP' (ip-addy ip.act))
    ==
  --
::
  ++  dejs
    =,  dejs:format
    |%
    ++  ip-addy
      ^-  $-(json ip:m)
      %-  of
      :~  ipv4+(se %if)
          ipv6+(se %is)
      ==
    ++  actions
      ^-  $-(json actions:m)
      %-  of
      :~  secret+_~
          answer+(ot secret+(se %uv) address+sa signature+sa ~)
        ::
          punish+ip-addy
          pardon+ip-addy
        ::
          :-  %clear
          %-  of
          :~  cache+|=(j=json ?~(j ~ `((se %uv) j)))
              fresh+ni:dejs-soft:format
              fails+ni:dejs-soft:format
          ==
      ==
    --
--