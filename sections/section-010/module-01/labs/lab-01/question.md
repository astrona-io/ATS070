# Question

Solve this question on: `terminal`

The platform team runs a Backstage portal for the Starfleet in the namespace `backstage`. A first review found that the portal still has generic settings and no recorded owner. Change the running portal as follows. Do not change the image and do not delete the Deployment.

1. The portal title must be `Starfleet Developer Portal`. The title is the value of `app.title` in the file `app-config.lab.yaml` of the ConfigMap `backstage-app-config`.

2. The catalog must accept only the entity kinds `Component`, `System`, `API`, `Resource` and `Location`. Add the setting `catalog.rules` to the same file, with one rule whose `allow` list contains these five kinds. The kind `Template` must not be in the list.

3. The Deployment `backstage` must record its owner. Add the annotation `portal.starfleet.example/owner` with the value `platform-team` to the Deployment object.

4. The backend reads its configuration only when it starts. Make the running pod use the new configuration, and wait until the new pod is ready.

5. The portal must still answer on its readiness endpoint through the Service `backstage` on port 7007.

`kubectl` already points at the cluster as the cluster administrator.
