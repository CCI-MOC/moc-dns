#!/bin/bash

tmpfile=$(mktemp .zonefileXXXXXX)
trap 'rm -f $tmpfile' EXIT

for zf in "$@"; do
  zonefile="$zf"
  zone="${zonefile##*/}"
  zone="${zone%.zone}"

  if ! [[ -f "$zonefile" ]]; then
    echo "ERROR: $zonefile does not exist" >&2
    exit 1
  fi

  named-checkzone -D -o "$tmpfile" "$zone" "$zonefile"

  # Ignore differences that are caused only by sort order
  # because apparently different builds of named-checkzone
  # can produce different ordering.
  if ! diff -u <(sort "$tmpfile") <(sort "$zonefile"); then
    cat "$tmpfile" >"$zonefile"
  fi
done
