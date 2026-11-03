# Question

Solve this question on: `terminal`

This is the Section 010 capstone: one repair task, no step-by-step guidance.

The platform team runs a Backstage portal in the namespace `backstage`. After a change, the pod of the Deployment `backstage` does not become ready. Repair and finish the portal. Do not change the image and do not scale the Deployment down.

1. The portal must start and become ready. The readiness endpoint on port 7007 of the Service `backstage` must answer.

2. The portal title (`app.title`) must be `Starfleet Developer Portal`.

3. The catalog must accept only the kinds `Component`, `System`, `API`, `Resource` and `Location`, set with `catalog.rules` and one `allow` list. The kind `Template` must not be allowed.

4. The Deployment must carry the annotation `portal.starfleet.example/owner` with the value `platform-team`.

5. Write the ConfigMap `portal-responsibilities` in `backstage` with these keys:
   - `owner`: `platform-team`.
   - `database`: one sentence that names the database that belongs in production for this portal and why the current one does not.
   - `identity`: one sentence that says who chooses and operates sign-in and permissions.
   - `release`: the release tag of the image.

`kubectl` already points at the cluster as the cluster administrator.
