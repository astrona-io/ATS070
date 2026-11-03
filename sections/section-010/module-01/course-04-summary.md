---
draft: true
exam_objectives:
- Understand the Backstage framework
---
# Summary

Backstage is a framework for building a developer portal. An organization assembles its own application from framework packages and plugins, builds it into an image and runs it. A running application has a frontend in the browser, a backend process, a database and configuration files. The portal presents information and starts actions, while external systems such as source hosts and deployment controllers do the real work.

The core features cover different tasks. The software catalog stores entities such as components, APIs, resources, systems, groups and users, most of them read from descriptor files. Software templates collect input and run actions through the scaffolder backend. TechDocs turns Markdown that lives next to the code into pages. Search indexes data from these features. Integrations hold the credentials that the backend uses to reach external systems, and the catalog rules limit which entity kinds a source may add.

The adopting organization owns the decisions around the framework: which features to install, how users sign in, what they may do, where the database runs, how secrets reach the backend, how releases are rolled out and how upgrades are scheduled. It also owns the quality of the content. A ready pod proves that the backend answers its health check. It does not prove that the data is complete, current or persistent.

Key facts:

- Backstage is a framework that an organization assembles, not a finished hosted product.
- The backend reads configuration files at start, so a changed file needs a restart to take effect.
- PostgreSQL is the production database. An in-memory SQLite database loses all data at a restart.
- A catalog entity describes software. It does not prove that the software runs.
- A feature needs three things: the plugin installed, the settings configured and the access permitted.

<!-- astrona:playground:destroy -->
