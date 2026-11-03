#!/usr/bin/env bash
# Check: catalog.rules has an allow list with the five kinds and without Template.
set -uo pipefail

file="$(kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}' 2>/dev/null)"
if ! echo "$file" | grep -Eq '^catalog:|^[[:space:]]*catalog:'; then
  echo "FAIL: no catalog block in app-config.lab.yaml"
  exit 1
fi
if ! echo "$file" | grep -Eq '^[[:space:]]*rules:'; then
  echo "FAIL: no catalog.rules in app-config.lab.yaml"
  exit 1
fi
allow="$(echo "$file" | grep -E 'allow:' | head -n 1)"
if [ -z "$allow" ]; then
  echo "FAIL: no allow list under catalog.rules"
  exit 1
fi
fail=0
for kind in Component System API Resource Location; do
  if ! echo "$allow" | grep -q "$kind"; then
    echo "FAIL: allow list does not contain $kind"
    fail=1
  fi
done
if echo "$allow" | grep -q "Template"; then
  echo "FAIL: allow list must not contain Template"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: catalog.rules allows only the five kinds"
exit "$fail"
