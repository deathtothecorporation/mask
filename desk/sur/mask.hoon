:: /sur/mask/hoon
::
/+  eths=ethereum, nav=naive, serve=server
|%
+$  ip      $%([%ipv4 @if] [%ipv6 @is])
+$  secret  @uv
+$  login   $@(%local ip)
+$  logins  (pair login @da)
::
++  actions
  =<  actions
  |%
  +$  actions 
    $%  [%clear =type]
        secrets-or-answers
        manage-banned-list
    ==
  ::
  +$  type
    $%  [%cache p=(unit secret)]                        :: manage your secrets
        [%fresh p=(unit @ud)]                           :: manage recent logins
        [%fails p=(unit @ud)]                           :: manage recent failure
    ==
  ::
  +$  secrets-or-answers
    $%  [%secret ~]                                     :: print a fresh secret.
        [%answer sec=secret ady=tape sig=tape]          :: attempt to get a code
    ==
  ::
  +$  manage-banned-list
    $%  [%punish =ip]                                   :: ban some ip address
        [%pardon =ip]                                   :: pardon a lost soul.
    ==
  --
::
+$  updates
  $%  [%a-secret sec=secret]                            :: added a challenge
      [%a-result wen=@da sec=secret way=login win=?]    :: attempted a login
  ==
--