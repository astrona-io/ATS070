---
draft: true
exam_objectives:
- Understand the Backstage framework
---
# Summary

A Backstage project is a monorepo with two entry packages and many plugin packages. The `app` package is the frontend and the `backend` package is the server. Both only wire plugins together. Plugin packages carry suffixes that name their side: `-backend` and `-node` for the server, `-react` for the frontend, `-common` for both. A plugin must use another plugin only through its library packages. A build turns the project into an image that runs `node packages/backend` with configuration files as arguments.

The backend system has four concepts. The backend instance starts everything. Plugins provide features and talk to each other over the network, below a path that contains their plugin ID. Services give each plugin shared functions such as the logger, the configuration and its own database. Extension points let a module add behaviour to exactly one plugin in the same instance. A package that is installed but not registered does not run.

The frontend app renders a tree of extensions. Plugins add extensions, overrides replace them, routes link plugins without fixed paths, and utility APIs carry calls to the backend. The browser can read everything it receives, so secrets stay in the backend.

Versions follow two rules. A release is a set of packages verified together, and the packages keep their own semantic versions. Core packages of one release must stay together, and the backend must be deployed before or with a frontend that depends on it.

Key facts:

- The `backend` package is a deployment unit, and plugins can be split across several of them.
- A module extends one plugin and runs in the same backend instance as that plugin.
- Each plugin gets its own database and its own HTTP path based on its plugin ID.
- Installing a package and registering it are two separate steps.
- Use the upgrade command of the Backstage command-line tool instead of changing package versions by hand.

<!-- astrona:playground:destroy -->
