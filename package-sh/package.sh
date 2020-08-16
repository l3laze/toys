#!/usr/bin/env bash
main () {
  local config
  local commands
  local parsing
  local usage
  local index

  config="$(<package-sh.conf)"
  printf -v usage "Usage:\n\
%s <command>|<sub-command> [options...]\n\n\
  Where the built-in commands are:\n\
help Display this message.\n\
list [like] Show list of sub-commands. If \"like\" is provided it's used as a regex to find similar commands.\n\n\
  ...and sub-commands, defined in package-sh.conf, are:\n%s" "${0/\.\//}" "$config"

  if [[ "$#" -eq 0 ]]; then
    echo -e "$usage"
    exit
  fi

  commands=""
  parsing=()

  mapfile -t parsing <<< "$(<package-sh.conf)"

  for ((index=0; index<="${#parsing}"; index++)); do
    if [[ "${parsing[$((index))]}" != "" ]]; then
      printf -v commands "%s\e[7m%s\e[27m %s\n" "$commands" "${parsing[((index))]/ */}" "${parsing[((index))]#* }"
    fi
  done

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
      help)
        echo -e "$usage"
      ;;
      init)
        printf "" > package-sh.conf
      ;;
      list)
        if [[ "$#" < 2 ]]; then
          printf "%s\n" "${commands[@]}"
        else
          shift
          grep "$1" <<< "$commands"
        fi
      ;;
      *)
         local grepc
         local greps
         grepc="$(grep -c $1 <<< $config)"
         greps="$(grep $1 <<< $config)"

         if [[ "$grepc" == "0" ]]; then
           echo "Unknown sub-command: $1."
         elif [[ "$grepc" != "1" ]]; then
           echo -e "Multiple sub-commands contain '$1':\n$greps"
         else
           eval "${greps#* }"
         fi
       ;;
    esac
  exit
  done
}
main "$@"
