---
draft: true
exam_objectives:
  - Configure Backstage
---
# Visibility, Typing And Secret Boundaries

This module explains how Backstage describes the shape of its configuration with schemas, how code reads values with types, which values reach the browser, and how a secret travels from Kubernetes to the backend without being written into a file. It then moves a leaked token out of a ConfigMap and into a Secret on a running deployment.

## Learning Goals

- Explain what a `config.d.ts` schema defines and how typed readers such as `getString` and `getOptionalString` behave.
- State the three visibility values `frontend`, `backend` and `secret`, the default, and what each means for the browser.
- Decide which settings may be visible to the browser and which must stay on the server.
- Deliver a secret to Backstage through a Kubernetes Secret and the `${NAME}` substitution, and rotate it.

## Before You Start

You should know what a Kubernetes Secret and a Deployment are, and how Backstage loads configuration files and environment overrides. The hands-on part uses a playground with a kind cluster and `kubectl`. Backstage runs there from a public container image. Technical terms are defined where they first appear.

## Reading Order

1. Configuration Schemas And Typed Reads
2. Visibility: What Reaches The Browser
3. Secret Delivery And Rotation
4. Summary

<!-- astrona:playground -->
