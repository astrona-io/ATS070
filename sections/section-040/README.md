---
draft: true
exam_objectives:
- Understand Backstage client-server architecture
---
# Understand Backstage client-server architecture

This section explains how a Backstage portal splits into a frontend app in the browser and a backend process on a server. It shows how a request travels between them, how the address and port settings fit together behind a reverse proxy, how backend plugins are reached, and how authentication, authorization and server-side credentials protect the data.

Read the two modules in order, practise in each playground, and solve the lab after the part it tests. The capstone lab then combines all the skills on one portal. The quiz at the end checks the section.

## Learning Outcomes

- Describe what runs in the browser and what runs in the backend, and follow a request between them.
- Set `app.baseUrl`, `backend.baseUrl`, `backend.listen` and `backend.cors.origin` for a reverse proxy.
- Explain plugin routes under `/api/<pluginId>`, discovery and the proxy plugin, and read error and empty states.
- Explain sign-in, user and service tokens, external access and the default auth policy.
- Explain permission decisions that the server enforces, and keep privileged credentials behind the backend.

## Modules

1. **Frontend, Backend And Service Discovery.** The browser app, the backend process, address keys, CORS, the reverse proxy, plugin routes and discovery. Includes a playground and a lab that sets the public address.
2. **Authentication, Authorization And Trust Boundaries.** Sign-in, tokens, external access, the default auth policy, the permission framework and credentials. Includes a playground and a lab that restores the auth policy and moves a token into a Secret.

The section also has a capstone lab and a quiz of ten questions.

## Hands-on status

All labs and playgrounds are UNTESTED. They were checked statically (`astrona validate -c`, `bash -n`, YAML parsing) and never run. Each lab README lists its open assumptions.
