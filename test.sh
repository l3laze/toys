#!/usr/bin/env bash

{
  test () {
    local actual="${2//(\x1b[[a-Z0-9;]+)/}" 
    local expected="$3"
    if [[ "$actual" == *"$3"* ]]; then
      printf " ✓ %s == %s\n" "$expected" "$actual"
    else
      printf " × %s != %s\n" "$expected" "$actual"
    fi
  }

  test "1" "$(./sind.sh <<< $'\e[A\n' 2>/dev/null)" $'up\nenter'
}
