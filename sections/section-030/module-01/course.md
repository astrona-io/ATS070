---
draft: true
exam_objectives:
- Deploy Backstage to production
---
# Packaging, Persistence And Database

This module covers what a production Backstage needs before it runs on Kubernetes: a container image that contains the built backend, a PostgreSQL database instead of the default in-memory SQLite, and a plan for migrations, backups and persistent data.

## What you will learn

- The host build steps and the container image that the official Backstage documentation describes, and how the host build differs from the multi-stage build.
- What is inside the image and what the process needs at start.
- Why in-memory SQLite loses all data when the pod restarts, and how the `backend.database` block selects PostgreSQL.
- How Backstage divides the database between plugins, and how to override the settings of one plugin.
- How migrations, backups and ownership of the persistent volume work.

## Parts

1. Building The Backstage Image
2. PostgreSQL And Plugin Databases
3. Migrations, Backups And Data Ownership

## Before you start

Your playground is a single-node `kind` cluster running Kubernetes 1.35. It has Backstage (image `ghcr.io/backstage/backstage:1.55.2`) and a PostgreSQL server running in the `backstage` namespace. Backstage listens on port 7007 and the port is forwarded to your machine. The Backstage pod starts on the default in-memory SQLite until you change its configuration. Every command in the parts runs against this cluster, and `kubectl` already points at it.

Launch your playground now, and keep it running next to you while you read the parts:

<!-- astrona:playground -->
