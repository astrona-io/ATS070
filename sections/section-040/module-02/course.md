---
draft: true
exam_objectives:
  - Understand Backstage client-server architecture
---
# Authentication, Authorization And Trust Boundaries

A portal that connects to source control, CI and clusters holds powerful credentials, and it answers requests from many callers. Three questions decide whether it is safe: who is asking, what may they do, and where do the credentials live. In this module you follow a request through authentication, the default auth policy, the permission framework and server-side credentials.

## Learning Goals

- Explain sign-in, user tokens, service tokens and external access.
- State what the default auth policy does and what disabling it means.
- Describe how the permission framework decides and where the decision is enforced.
- Keep credentials out of the browser and out of the ConfigMap.

## Before You Start

You need basic Kubernetes (Deployments, ConfigMaps, Secrets, `kubectl rollout`) and an idea of HTTP headers and status codes. You do not need to know Backstage.

Your playground is a single-node `kind` cluster with one Backstage Deployment in the namespace `backstage`, a Service on port 7007, the ConfigMap `backstage-app-config` and the Secret `portal-secrets`. `kubectl` already points at it. Launch it now and keep it running while you read:

<!-- astrona:playground -->

## Reading Order

1. Sign-In, Identity And Service Authentication
2. Permission Decisions On The Server
3. Privileged Integrations And Credentials
4. Summary
