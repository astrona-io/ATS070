#!/usr/bin/env bash
# Check: a second configuration file is the last --config flag and keeps the
# first one before it; the new ConfigMap sets the title.
set -uo pipefail

fail=0
args="$(kubectl -n backstage get deployment backstage -o json | jq -r '.spec.template.spec.containers[0].args | join(" ")')"
case "$args" in
  *"/etc/backstage/app-config.lab.yaml"*) ;;
  *) echo "FAIL: the first file /etc/backstage/app-config.lab.yaml is no longer an argument"; fail=1 ;;
esac
last="$(kubectl -n backstage get deployment backstage -o json | jq -r '.spec.template.spec.containers[0].args | .[-2] + " " + .[-1]')"
if [ "$last" != "--config /etc/backstage-extra/app-config.extra.yaml" ]; then
  echo "FAIL: the last two arguments are '$last', expected '--config /etc/backstage-extra/app-config.extra.yaml'"
  fail=1
fi
file="$(kubectl -n backstage get configmap backstage-app-config-extra -o jsonpath='{.data.app-config\.extra\.yaml}' 2>/dev/null)"
if ! echo "$file" | grep -Eq '^[[:space:]]+title:[[:space:]]*"?Starfleet Operations Portal"?[[:space:]]*$'; then
  echo "FAIL: ConfigMap backstage-app-config-extra does not set app.title to Starfleet Operations Portal"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: the extra file is the last configuration layer and sets the title"
exit "$fail"
