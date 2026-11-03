---
draft: true
exam_objectives:
  - Understand Backstage client-server architecture
---
# Summary

Authentication asks who the caller is, and authorization asks what the caller may do. People sign in through an auth provider and receive a user token, a signed JWT that the frontend attaches to each API call. Plugins call each other with service tokens that the auth service issues. External callers such as a CI pipeline use entries under `backend.auth.externalAccess`, either a static token or a `jwks` setup, and `accessRestrictions` limit each entry to named plugins.

The backend applies a default auth policy that requires credentials on every plugin route. Plugins can open single routes with `addAuthPolicy`. The key `backend.auth.dangerouslyDisableDefaultAuthPolicy` switches the policy off and exists for development. The status code of a rejected request is not documented as a fixed value, so a test should check that the request does not succeed.

The permission framework is enabled with `permission.enabled: true`. A policy returns ALLOW, DENY or CONDITIONAL for a principal and a permission, and the plugin that owns the data enforces the decision. The default policy allows everything, so enabling the framework does not restrict anyone until a policy with rules exists. A frontend check hides a button but does not protect a route.

Privileged credentials stay in the backend because the browser is outside the trust boundary. Configuration keys have the visibility `frontend`, `backend` or `secret`, and only `frontend` keys reach the browser. Tokens belong in a Kubernetes Secret, are passed to the container as an environment variable and appear in the configuration only as a `${NAME}` placeholder. The backend still has to filter results by what the caller may see.

- Authentication comes before authorization.
- Default auth policy on means credentials on every route.
- `permission.enabled: true` with the default policy still allows everything.
- A token in a ConfigMap is a finding; a placeholder plus a Secret is the fix.

<!-- astrona:playground:destroy -->
