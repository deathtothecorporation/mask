# Mask

> **Disclaimer**: This project is no longer maintained. Feel free to fork and
improve it if you'd like - it is [vaporware](LICENSE) after all.
>
> Vaporware wishes to thank all the contributors: [ryjm](https://github.com/ryjm), [yungcalibri](https://github.com/yungcalibri), [vcavallo](https://github.com/vcavallo) and of course [rabsef-bicrym](https://github.com/rabsef-bicrym)

`%mask` allows a pilot to log into their urbit with MetaMask from a public
page.

This application is ideal for being included in a hosting custom pill such that a
new user can log into their urbit for the first time, unassisted.

## General Use:

1. Navigate to `https://<your-ship-url>/apps/mask/login`
2. "Connect" MetaMask to the account that holds this Azimuth point
3. Click "Log in" and sign the message from MetaMask
4. You will be redirected to your logged-in ship via standard urbit cookies.

### To be sent directly to a particular app:

1. Navigate to the same URL as above, but specify query parameters:
  - `appRoute` - the app's path to be appended to your ship URL
  - `desk` - the human-readable name to display in the %mask UI
  - Full contrived example:
  `https://<your-ship-url>/apps/mask/login?appRoute=/apps/groups&desk=%25urbit-groups`.
    - This would show "Connect your wallet to access the installed vaporware: %urbit-groups" (the latter bit here coming from the `desk` parameter) and upon successfully signing, would be redirected to `https://<your-ship-url>/apps/groups` (the `appRoute` specified)
    - Note, the `%25` in the 'desk' parameter _renders a literal `%` sign in the UI_
  - Optionally pass the `vapor` query parameter with any value to present the
  desk as 'vaporware'
2. Follow steps 2-4 above

## Requirements

- Zuse kelvin 412

## Dev Setup

There are some scripts in `bin/` for helping with building and serving the
`public-ui` interface. In particular, `bin/serve-interface.sh <your urbit port.
like 8081>` is helpful if you have multiple local ships running and need to
point the UI at one.

## Urbit desk

`desk` - [TODO: details about the urbit desk]

## Public UI

`public-ui` is a simple Vue3 app that supplies a basic public-facing login page,
which is served by eyre.

See `public-ui/README.md` for more.

Use `deploy.sh` to build the UI and copy the `index.js` file to the `desk`
directory. TODO: make this deploy script do all the things, instead of just
index.js

## Admin UI

**Coming soon**

`admin-ui` is a Vue3 app, served as a glob/urbit app to allow the ship operator
to configure `%mask`.

See `admin-ui/README.md` for more.
