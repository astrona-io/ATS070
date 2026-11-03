#!/usr/bin/env bash
# Check: the Deployment loads the production file with --config, after the
# existing flags, from a mounted ConfigMap volume.
set -uo pipefail

dep="$(kubectl -n backstage get deployment backstage -o json 2>/dev/null)"
if [ -z "$dep" ]; then
  echo "FAIL: Deployment backstage not found"
  exit 1
fi

path="/etc/backstage-production/app-config.production.yaml"
last_flag="$(echo "$dep" | jq -r '.spec.template.spec.containers[0].args | last')"
before_last="$(echo "$dep" | jq -r '.spec.template.spec.containers[0].args | .[-2]')"
lab_index="$(echo "$dep" | jq '.spec.template.spec.containers[0].args | index("/etc/backstage/app-config.lab.yaml")')"
prod_index="$(echo "$dep" | jq --arg p "$path" '.spec.template.spec.containers[0].args | index($p)')"

fail=0
if [ "$prod_index" = "null" ]; then
  echo "FAIL: the args do not contain $path"
  fail=1
elif [ "$lab_index" = "null" ] || [ "$prod_index" -le "$lab_index" ]; then
  echo "FAIL: the production file must come after /etc/backstage/app-config.lab.yaml in the args"
  fail=1
elif [ "$last_flag" != "$path" ] || [ "$before_last" != "--config" ]; then
  echo "FAIL: the production file must be the last --config flag"
  fail=1
fi

mount="$(echo "$dep" | jq -r '.spec.template.spec.containers[0].volumeMounts[]? | select(.mountPath == "/etc/backstage-production") | .name')"
if [ -z "$mount" ]; then
  echo "FAIL: no volume is mounted at /etc/backstage-production"
  fail=1
else
  source_cm="$(echo "$dep" | jq -r --arg n "$mount" '.spec.template.spec.volumes[]? | select(.name == $n) | .configMap.name')"
  if [ "$source_cm" != "backstage-app-config-production" ]; then
    echo "FAIL: the volume at /etc/backstage-production must come from the ConfigMap backstage-app-config-production"
    fail=1
  fi
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the production file is mounted and is the last --config flag"
fi
exit "$fail"
