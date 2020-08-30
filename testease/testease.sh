#!/usr/bin/env bash

set -euo pipefail

run () {
  local timer
  local label
  local actual
  local expected
  local passed=0
  local total=0

  if command -v "shellcheck" > /dev/null 2>&1; then
    echo "shellcheck"
    shellcheck ./*.sh || exit 64
  else
    echo -e >&2 "Warning: Need shellcheck installed for linting.\n" # LCOV_EXCL_LINE
  fi

  testease () {
    label="${1:?testease requires a label}"
    actual="${2:?testease requires actual value}"
    expected="${3:?testease requires expected value}"
    ((total += 1))

    if [[ "$actual" == *"$expected"* ]]; then
      printf "  ✓ %s\n" "$label"
      ((passed += 1))
    else
      printf "  × %s\n      %s != %s\n" "$label" "$actual" "$expected" # LCOV_EXCL_LINE
    fi
  }

  timer="$(date +%s%3N)"

  if [[ ("$#" -eq 1 && -f "$1") ]]; then
    # shellcheck source=/dev/null
    source "$1"
  else
    echo >&2 "No test file specified."
    exit 64
  fi

  echo -e "\n$passed/$total passed"

  timer="$(($(date +%s%3N) - timer))"

  printf "Finished in %s.%s seconds\n" "$((timer / 1000))" "$((timer % 1000))"

  if [[ "$passed" -lt "$total" ]]; then
    exit 64 # LCOV_EXCL_LINE
  fi
}

run "$@"
