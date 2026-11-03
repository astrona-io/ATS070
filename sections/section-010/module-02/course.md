---
draft: true
exam_objectives:
- Understand the Backstage framework
---
# Application Anatomy: Frontend, Backend And Plugins

This module opens a Backstage application and names its parts: the packages of the project, the backend system with its plugins, modules, extension points and services, and the frontend with its extensions. It then covers how versions and upgrades work, because every part has its own release number.

## Learning Goals

- Name the standard packages of a Backstage project and the role of each one.
- Explain how the backend system combines plugins, modules, extension points and services.
- Explain how the frontend builds an application from plugins and extensions.
- Explain the version rules that decide whether a set of packages can run together.

## Before You Start

You should know what a pod, a Deployment and a ConfigMap are, and have a basic idea of what a Node.js package is. The hands-on part uses a playground with a kind cluster and `kubectl`.

## Reading Order

1. The Project Layout: App, Backend And Plugin Packages
2. The Backend System: Plugins, Modules, Extension Points And Services
3. The Frontend, Versions And Upgrades
4. Summary

<!-- astrona:playground -->
