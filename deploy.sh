#!/bin/bash

npm run build --prefix public-ui
cp public-ui/dist/assets/index.js desk/app/mask/assets/index.js
cp public-ui/dist/assets/style.css desk/app/mask/assets/style.css
cp public-ui/dist/index.html desk/app/mask/index.html
