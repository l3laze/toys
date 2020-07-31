#!/usr/bin/env bash

set -euo pipefail

key_input () {
  local key
  IFS=; read -rsN 1
  key="$REPLY"

    if [[ "$key" =~ ^[A-Za-z0-9]$ ]]; then printf "%s" "$key";
  elif [[ "$key" == $'\n' ]]; then printf "enter";
  elif [[ "$key" == $' ' ]]; then printf "space";
  elif [[ "$key" == $'\e' ]]; then
    IFS=; read -rsN 2 -t 0.01
      if [[ "$REPLY" == "[A" ]]; then printf "up";
    elif [[ "$REPLY" == "[B" ]]; then printf "down";
    fi
    key=;
  fi
}

while true; do
  in="$(key_input)"

  printf "%s\n" "$in"

  if [[ "$in" == "enter" ]]; then
    exit
  fi
done
