#!/usr/bin/env bash
# Check: an Ingress named backstage sends the host portal.starfleet.example.com
# to the Service backstage on port 7007.
set -uo pipefail

ingress="$(kubectl -n backstage get ingress backstage -o json 2>/dev/null)"
if [ -z "$ingress" ]; then
  echo "FAIL: no Ingress named backstage in the namespace backstage"
  exit 1
fi

match="$(echo "$ingress" | jq '[.spec.rules[]?
  | select(.host == "portal.starfleet.example.com")
  | .http.paths[]?
  | select(.backend.service.name == "backstage" and .backend.service.port.number == 7007)] | length')"
if [ "$match" -lt 1 ]; then
  echo "FAIL: the Ingress has no rule that sends portal.starfleet.example.com to backstage:7007"
  exit 1
fi
echo "PASS: the Ingress routes portal.starfleet.example.com to backstage:7007"
