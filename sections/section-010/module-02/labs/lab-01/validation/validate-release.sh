#!/usr/bin/env bash
# Check: anatomy-record has the release tag of the image.
set -uo pipefail

value="$(kubectl -n backstage get configmap anatomy-record -o jsonpath='{.data.release}' 2>/dev/null)"
image="$(kubectl -n backstage get deployment backstage -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
if [ -n "$value" ] && [ "${image##*:}" = "$value" ]; then
  echo "PASS: release is $value"
  exit 0
fi
echo "FAIL: release is '$value', the image is '$image'"
exit 1
