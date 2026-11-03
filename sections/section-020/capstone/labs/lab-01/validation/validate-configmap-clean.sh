#!/usr/bin/env bash
# Check: no ConfigMap in the namespace contains token text, and the mounted
# file refers to ${SCM_TOKEN} while keeping its other settings.
set -uo pipefail

fail=0
leaks="$(kubectl -n backstage get configmaps -o json | jq -r '.items[] | select(any(.data[]?; test("ghp_"))) | .metadata.name')"
if [ -n "$leaks" ]; then
  echo "FAIL: ConfigMap still holds token text: $leaks"
  fail=1
fi

text="$(kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}' 2>/dev/null)"
if [ -z "$text" ]; then
  echo "FAIL: ConfigMap backstage-app-config has no key app-config.lab.yaml"
  exit 1
fi
if ! echo "$text" | grep -Eq 'token:[[:space:]]*"?\$\{SCM_TOKEN\}"?[[:space:]]*$'; then
  echo "FAIL: integrations.github token is not the reference \${SCM_TOKEN}"
  fail=1
fi
for key in "title: Starfleet Portal" "baseUrl: http://localhost:7007" "client: better-sqlite3"; do
  if ! echo "$text" | grep -Fq "$key"; then
    echo "FAIL: the file lost the setting '$key'"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: no ConfigMap holds the token and the file uses the reference"
fi
exit "$fail"
