#!/usr/bin/env bash

set -euo pipefail

main () {
  local commands
  local parsing
  local usage
  local part

  commands=""
  parsing=()

  mapfile -t parsing < package-sh.conf

  for part in "${parsing[@]}"; do
    if [[ "$part" != "" ]]; then
      printf -v commands "%s\e[7m%s\e[27m %s\n" "$commands" "${part/ */}" "${part#* }"
    fi
  done

  printf -v usage "Usage:\n\
%s <command>|<sub-command> [options...]\n\n\
  Where the built-in commands are:\n\
help Display this message.\n\
list [like] Show list of sub-commands. If \"like\" is provided it's used as a regex to find similar commands.\n\n\
  ...and sub-commands, defined in package-sh.conf, are:\n%s" "${0/\.\//}" "$commands"

  if [[ "$#" -eq 0 ]]; then
    echo -en "$usage"
    exit
  fi

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      help)
        echo -en "$usage"
      ;;
      init)
        printf "" > package-sh.conf
      ;;
      list)
        if [[ "$#" < 2 ]]; then
          echo -en "%s" "$commands"
        else
          shift
          grep "$1" <<< "$commands"
        fi
      ;;
      *)
         local grepc
         local greps
         grepc="$(grep -c $1 <<< $commands)"
         greps="$(grep $1 <<< $commands)"

         if [[ "$grepc" == "0" ]]; then
           echo "Unknown sub-command: $1."
         elif [[ "$grepc" != "1" ]]; then
           echo -en "Multiple sub-commands contain '$1':\n$greps\n"
         else
           eval "${greps#* }"
         fi
       ;;
    esac
  exit
  done
}
main "$@"
