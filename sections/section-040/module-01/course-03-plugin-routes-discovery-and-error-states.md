---
draft: true
exam_objectives:
  - Understand Backstage client-server architecture
---
# Plugin Routes, Discovery And Error States

One backend process hosts many plugins, and the browser, other plugins and external tools all need to reach them. Hard-coding a URL for each plugin would break whenever the deployment changes. Backstage solves this with a fixed route pattern and a discovery service. This part shows the route pattern, explains how callers look up a plugin address, describes the proxy plugin for reaching external systems, and then looks at what the user sees when a call fails or returns nothing.

## Routes under /api/<pluginId>

Every backend plugin has a **plugin ID**, a short name such as `catalog`, `scaffolder`, `techdocs` or `permission`. The backend mounts the HTTP router of each plugin under `/api/<pluginId>`. The catalog list of entities therefore lives at `/api/catalog/entities`, and the plugin decides what comes after its own prefix.

Because the pattern is fixed, one public address and one port are enough for all plugins. The route prefix also gives the platform team one place to apply rules: a reverse proxy can match `/api` once, and the backend applies authentication to each plugin route.

## Discovery: finding a plugin base URL

A caller needs the base URL of a plugin, not just its ID. The **discovery service** turns a plugin ID into a base URL. Two forms exist. The internal form, `getBaseUrl`, returns the address used between services that can reach the backend directly. The external form, `getExternalBaseUrl`, returns the address used by clients outside, such as the browser.

On the frontend side the same idea is called the `DiscoveryApi`. A frontend plugin asks it for the base URL of the plugin it needs and then appends its own route:

```ts
const baseUrl = await discoveryApi.getBaseUrl('catalog');
const response = await fetchApi.fetch(`${baseUrl}/entities`);
```

The first line asks discovery for the catalog address. The second line sends the request and appends `/entities`. The `fetchApi` attaches the credentials of the signed-in user to the request, which the next topic explains in detail.

Discovery builds its answers from configuration. The address comes from `backend.baseUrl` and the plugin ID, which is why a wrong `backend.baseUrl` breaks every plugin at once. A single wrong key therefore affects all calls that use discovery, and none that bypass it.

## Backend-to-backend calls

Plugins also call each other. The scaffolder reads from the catalog, and the search plugin collects documents from other plugins. A backend plugin asks the discovery service of the backend for the base URL of the other plugin, then sends an HTTP request. These calls carry service credentials, not a user session. When plugins run in one process, the base URL still resolves to the same server, so the call passes through the same authentication checks as an outside call.

## The proxy plugin

Sometimes the browser needs data from a system that Backstage does not wrap in its own plugin, for example a team status API. The **proxy backend plugin** forwards requests from the Backstage backend to a configured target. Its configuration sits under the root key `proxy`:

```yaml
proxy:
  endpoints:
    /status:
      target: https://status.starfleet.example
      credentials: require
```

The proxy plugin has the plugin ID `proxy`, so this route serves requests at `/api/proxy/status/...` and forwards them to the target. The `credentials` field controls who may call. The default, `require`, means the caller must send valid Backstage credentials, and those credentials are not forwarded to the target. The value `forward` also forwards them. The value `dangerously-allow-unauthenticated` turns off the check for this route.

A route can also carry a `headers` map that the proxy adds to the outgoing request. This is how the backend attaches a token for the target without the browser ever seeing it. The value `${STATUS_TOKEN}` reads an environment variable when the process starts. If `backend.auth.dangerouslyDisableDefaultAuthPolicy` is `true`, the proxy ignores `credentials` and every route behaves as unauthenticated.

## Try it in the playground

Check the status of one plugin route and one route that does not exist, from inside the pod:

<!-- astrona:playground:renew -->

```sh
kubectl -n backstage exec deploy/backstage -- node -e "fetch('http://localhost:7007/api/catalog/entities').then(r => console.log(r.status))"
kubectl -n backstage exec deploy/backstage -- node -e "fetch('http://localhost:7007/api/no-such-plugin/x').then(r => console.log(r.status))"
```

Each command prints one HTTP status. The statuses can differ, because the first path belongs to a mounted plugin and the second one does not. The exact numbers depend on the authentication settings of the image and are not documented as fixed values, so read them from your own run instead of assuming them.

Then read the backend log for the lines that name the plugins that started:

```sh
kubectl -n backstage logs deploy/backstage
```

The log shows which plugins the backend loaded and on which port it listens. A plugin that is missing from the log has no route.

## Reading errors and empty states

A call can end in three different ways, and the user interface treats them differently. An **error** means the request failed: a network failure, or a status such as 401, 403, 404 or 500. An **empty state** means the request worked and the answer holds no items. A **partial state** means some data arrived and some did not.

The difference matters for fault finding. An empty catalog table with status 200 says that the backend has no entities, for example because no catalog locations are configured. An error panel with status 401 says that the credentials were missing or invalid. A table that never loads, with no response at all, points to addresses or the proxy.

Use the status code first, then the body. A 401 means the caller is not authenticated. A 403 means the caller is known but not allowed. A 404 means the route or the item does not exist. A 5xx status means the backend failed, and the backend log has the reason. Frontend plugins decide how to show these cases, so the same status can look different on different pages.

A practical way to work is to send the failing request again from a terminal and compare. If the terminal request returns the same status as the browser, the cause is in the backend or its configuration. If the terminal request works and the browser fails, look at CORS, cookies and the credentials that the browser attaches.

This part showed how a request finds the right plugin and how failures appear. The remaining question is who is allowed to make each request, which is the subject of authentication and authorization.

## Common pitfalls

> [!WARNING]
> - **Hard-coding plugin URLs.** Use the discovery API, so a change of `backend.baseUrl` reaches every caller.
> - **Reading an empty table as an error.** Status 200 with no items is an empty state. Check the status before the backend log.
> - **Proxy routes with `dangerously-allow-unauthenticated`.** Such a route lets anyone reach the target, with whatever credentials the proxy attaches.
> - **Forgetting that the proxy ignores `credentials` when the default auth policy is disabled.** Every route is then open.
