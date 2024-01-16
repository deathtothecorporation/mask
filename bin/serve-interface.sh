#!/bin/bash

# Call with optional override to VITE_URBIT_TARGET like so:

if [ -n "$1" ]
then
  PORT=$1
  export VITE_URBIT_TARGET="http://localhost:$PORT"
fi

echo "Serving interface on: $VITE_URBIT_TARGET..."
npm run serve --prefix public-ui
