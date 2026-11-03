---
draft: true
exam_objectives:
  - Deploy Backstage to production
---
# Running On Kubernetes: Secrets, Probes And Releases

This module turns the container image and the database into a running service on Kubernetes. It covers the Deployment, the Service, the Ingress and the base URL, then the Secrets and probes that make the service safe to run, and finally how releases and rollbacks work.

## What you will learn

- How a Deployment, a Service and an Ingress route a request to the Backstage port 7007.
- Why `app.baseUrl`, `backend.baseUrl` and the CORS origin must match the public address.
- How a Secret reaches the process through `envFrom`, and why a changed Secret needs a restart.
- What the backend health endpoints report and how readiness and liveness probes use them.
- How `replicas`, `maxSurge` and `maxUnavailable` control a rolling update, and how to roll back.
- Why a green rollout does not prove that every feature works.

## Parts

1. Deployment, Service, Ingress And Base URLs
2. Secrets And Health Probes
3. Rolling Releases And Feature Health

## Before you start

Your playground is a single-node `kind` cluster running Kubernetes 1.35, with Backstage and PostgreSQL already running in the `backstage` namespace and port 7007 forwarded to your machine. Every command in the parts runs against this cluster, and `kubectl` already points at it.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
