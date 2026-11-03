---
draft: true
exam_objectives:
  - Understand Backstage client-server architecture
---
# Summary

Backstage is a client-server application. The frontend app is a bundle of JavaScript that runs in the browser of the user and calls APIs over HTTP. The backend is a Node.js process on a server that runs the backend plugins, reads the database and calls other systems. The browser is not trusted with private data, so the backend checks every request itself. Configuration keys have a visibility of `frontend`, `backend` or `secret`, and only `frontend` keys reach the browser.

Three keys answer three address questions. `app.baseUrl` is the address users type, `backend.baseUrl` is the address clients use to reach the backend, and `backend.listen` is the port and host the process binds to. A reverse proxy lets all of them share one public address while the process keeps listening on port 7007. `backend.cors.origin` must equal the origin of the page exactly, and CORS is a browser rule that tools such as `curl` ignore. Backstage reads its configuration at startup, so a changed ConfigMap needs a restart.

The backend mounts each plugin under `/api/<pluginId>`. The discovery service turns a plugin ID into a base URL, internal for calls between services and external for clients outside. The proxy plugin forwards requests under `/api/proxy` to configured targets, and its `credentials` field decides who may call. When a call fails, the status code tells the cause: 401 for missing credentials, 403 for a missing permission, 404 for a missing route or item, and 5xx for a backend failure. A 200 response with no items is an empty state, not an error.

- The browser app and the backend are two programs in two places.
- The listen port is the inside; the base URL is the outside.
- Every plugin route lives under `/api/<pluginId>`.
- A change to the configuration takes effect after a restart.

<!-- astrona:playground:destroy -->
