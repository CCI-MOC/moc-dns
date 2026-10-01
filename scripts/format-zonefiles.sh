#!/bin/bash

tmpfile=$(mktemp .zonefileXXXXXX)
trap 'rm -f $tmpfile' EXIT

for zonefile in "$@"; do
  zone="${zonefile##*/}"
  zone="${zone%.zone}"

  if ! [[ -f "$zonefile" ]]; then
    echo "ERROR: $zonefile does not exist" >&2
    exit 1
  fi

  if ! ldns-read-zone -c "$zonefile" >"$tmpfile"; then
    echo "ERROR: failed to validate zonefile \"$zonefile\"" >&2
    exit 1
  fi

  if ! diff -u "$tmpfile" "$zonefile"; then
    cat "$tmpfile" >"$zonefile"
  fi
done
