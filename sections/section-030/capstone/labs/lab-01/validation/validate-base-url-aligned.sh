#!/usr/bin/env bash
# Check: app.baseUrl, backend.baseUrl and backend.cors.origin all use the
# public address https://portal.starfleet.example.com.
set -uo pipefail

config="$(kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}' 2>/dev/null)"
public="https://portal.starfleet.example.com"
fail=0

section_value() {
  # Prints the value of key $2 inside the top-level block $1 (indentation based).
  echo "$config" | awk -v block="$1" -v key="$2" '
    /^[^[:space:]]/ { in_block = ($0 == block ":") }
    in_block && $1 == key ":" { print $2 }'
}

app_base="$(section_value app baseUrl)"
backend_base="$(section_value backend baseUrl)"
cors_origin="$(echo "$config" | awk '/^backend:/{b=1;next} /^[^[:space:]]/{b=0} b&&/^[[:space:]]+cors:/{c=1;next} b&&c&&$1=="origin:"{print $2; exit}')"

[ "$app_base" = "$public" ] || { echo "FAIL: app.baseUrl is '$app_base', expected $public"; fail=1; }
[ "$backend_base" = "$public" ] || { echo "FAIL: backend.baseUrl is '$backend_base', expected $public"; fail=1; }
[ "$cors_origin" = "$public" ] || { echo "FAIL: backend.cors.origin is '$cors_origin', expected $public"; fail=1; }

if [ "$fail" -eq 0 ]; then
  echo "PASS: app.baseUrl, backend.baseUrl and backend.cors.origin use $public"
fi
exit "$fail"
