---
draft: true
exam_objectives:
  - Understand Backstage client-server architecture
---
# Frontend, Backend And Service Discovery

A Backstage portal is two programs. A frontend app runs in the browser, and a backend process runs on a server and hosts the plugins. Most installation problems come from not knowing which program does a job, or from one wrong address in the configuration. In this module you separate the two programs, follow a request through them, set the address keys correctly behind a reverse proxy, and read what a failure looks like.

## Learning Goals

- Describe what runs in the browser and what runs in the backend, and follow one request between them.
- Set `app.baseUrl`, `backend.baseUrl`, `backend.listen` and `backend.cors.origin` for a reverse proxy.
- Explain how plugin routes, the discovery service and the proxy plugin fit together.
- Tell an error from an empty state using the HTTP status.

## Before You Start

You need basic Kubernetes (namespaces, Deployments, ConfigMaps, `kubectl get` and `kubectl rollout`) and a working idea of HTTP requests and status codes. You do not need to know Backstage.

Your playground is a single-node `kind` cluster with one Backstage Deployment in the namespace `backstage`, a Service on port 7007 and a ConfigMap `backstage-app-config`. `kubectl` already points at it. Launch it now and keep it running while you read:

<!-- astrona:playground -->

## Reading Order

1. Browser App, Backend Process And The Request Path
2. Base URLs, Listen, CORS And The Reverse Proxy
3. Plugin Routes, Discovery And Error States
4. Summary
