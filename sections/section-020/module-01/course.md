---
draft: true
exam_objectives:
  - Configure Backstage
---
# Configuration Files, Merging And Overrides

This module explains how a Backstage application builds its effective configuration from several sources: files, command-line flags, environment variables and substituted values. It then changes the configuration of a running Backstage deployment on Kubernetes and checks the result.

## Learning Goals

- Name the configuration files Backstage reads and the order in which later sources replace earlier ones.
- Predict the merged result when two files set the same object, primitive value or array, and when one sets a value to `null`.
- Use `APP_CONFIG_` environment variables and the `$env`, `$file` and `$include` substitutions, and say which one wins.
- Load an additional configuration file into a Kubernetes deployment of Backstage with the `--config` flag.

## Before You Start

You should know what a Kubernetes Deployment, a ConfigMap and a pod are, and how to read YAML. The hands-on part uses a playground with a kind cluster and `kubectl`. Backstage runs there from a public container image. Technical terms are defined where they first appear.

## Reading Order

1. App Configuration Files And The `--config` Order
2. Merge Rules: Objects, Primitives, Arrays And `null`
3. Environment Overrides And Substitutions
4. Summary

<!-- astrona:playground -->
