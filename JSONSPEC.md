# Mask JSON Spec
Mask is a tool for logging in to an Urbit using an ethereum signature. Mask checks the ownership address as stored in `azimuth`'s `point` construction and confirms that the signed message is from the same address. If it is, Mask releases a cookie just like logging in with `+code`; if not, you get NOTHING!

Mask also has a management dashboard that will show you:
1. The list of secrets that are currently "live" for signing.
  - A new secret is generated using entropy each time a user `GET` requests the login page.
  - Secrets are live for 5 minutes, whereupon they auto-terminate
2. The list of recent logins (ip address and date)
  - Capped to 25, shows last 25 successful logins
3. The list of failed logins (ip address and date)
  - Capped to 25, shows last 25 failed logins
  - Note, local login attempts (through the terminal) are not added to this list. These require being on the ship anyway (`=(our.bol src.bol)`), so they are only for testing purposes and we didn't want to wipe out important data with these.
4. A set of banned ip address
  - If someone is attempting to brute force your mask login, you can simply ban the IP address and prevent future attempts from ever succeeding (or even being processed fully)

Lastly, Mask has some administrative actions that affect the state of Mask. Those actions follow:

-  [%clear =type]
  * type: ?([%cache (unit secret)] [%fresh (unit @ud)] [%fails (unit @ud)])
  * Here, a null unit clears ALL of a state object (caches, recent, failed respectively), while a specified secret clears that secret, and a specified @ud clears that many (first in, first out) from the lists of recent and failed logins (respectively).
- [%secret ~]
  * Generates a secret in the terminal
- [%answer secret=@uv address=tape signature=tape]
  * Allows answering a challenge in the terminal
- [%punish ip=?([%ipv4 @if] [%ipv6 @is])]
  * Bans an IP address
- [%pardon =ip]
  * Unbans an IP address

##  Actions

###  clear
  - [%clear type=?([%cache (unit secret)] [%fresh (unit @ud)] [%fails (unit @ud)])]
    - expects
      ```json
      {
        "clear": {
          "cache": null || "0v12345"
        } ||   {
          "fresh": null ||  5
        } ||   {
          "fails": null ||  5
        }
      }
      ```
    - returns
      (cache)
      ```json
      {
        "type": "FACT",
        "face": "CACHES-CLEAR",
        "type": "ALL" || "0v12345"
      }
      ```
      (fresh)
      ```json
      {
        "type": "FACT",
        "face": "RECENT-CLEAR",
        "type": "ALL" || {"number": 5}
      }
      ```
      (fails)
      ```json
      {
        "type": "FACT",
        "face": "FAILED-CLEAR",
        "type": "All" || {"number": 5}
      }
      ```

###  secret-or-answer
  - [%secret ~]
    - expects
      ```json
      {
        "secret": null
      }
      ```
    - returns (immediately)
      ```json
      {
        "type": "FACT",
        "face": "CACHES-ADD-SECRET",
        "fact": "AWAIT UPDATE"
      }
      ```
    - returns (eventually)
      ```json
      {
        "type": "FACT",
        "face": "CACHES-NEW-SECRET",
        "fact": {"new-secret": "0v12345"}
      }
      ```
  - [%answer =secret(@uv) =address(tape) =signatures(tape)]
    - expects
      ```json
      {
        "answer": {
          "secret": "0v12345",
          "address": "<an ethereum address without 0x>",
          "signature": "<a signature without 0x>"
        }
      }
      ```
    - returns (immediately)
      ```json
      {
        "type": "FACT",
        "face": "CACHES-ANSWER-SUBMITTED",
        "fact": {
          "secret": "0v12345",
          "address": "0x12345",
          "signature": "0x12345"
        }
      }
      ```
    - returns (eventually)
      ```json
      {
        "type": "FACT",
        "face": "CACHES-ANSWER-RESULT",
        "fact": {
          "attempt-date": "16012345",
          "secret-used": "0v12345",
          "login-method": "LOCAL" || {
            "protocol": "ipv4" || "ipv6",
            "address": "0x12345"
          }
        }
      }
      ```
###  manage-banned-list
  - [%punish =ip-address]
    - NOTE: IP Address can be in the following formats:
      ```json
      {
        "ipv4": ".192.168.1.1"
      }
      ```
      ```json
      {
        "ipv6": ".32ba.f418.c35e.67ca.819f.f805.39b3.11ed"
      }
      ```
    - expect
      ```json
      {
        "punish": {
          <an IP address per spec above>
        }
      }
      ```
    - returns (note that the protocol and address vary on what was blocked)
      ```json
      {
        "type": "FACT",
        "face": "BANNED-BAN-IP",
        "fact": {
          "ip-address": {
            "protocol": "ipv4",
            "address": ".192.168.1.1"
          }
        }
      }
      ```
  
  - [%pardon =ip-address]
    - expects
      ```json
      {
        "pardon": {
          <an IP address per spec above>
        }
      }
      ```
    - returns
      ```json
      {
        "type": "FACT",
        "face": "BANNED-UNBAN-IP",
        "fact": {
          "ip-address": {
            "protocol": "ipv4",
            "address": ".192.168.1.1"
          }
        }
      }
      ```
