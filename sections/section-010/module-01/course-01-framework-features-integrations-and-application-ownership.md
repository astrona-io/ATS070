---
draft: true
exam_objectives:
- Understand the Backstage framework
---
# Framework Features, Integrations And Application Ownership

Backstage is a framework for creating developer portals. An organization assembles an application from framework packages, plugins and its own integrations. The portal can present software ownership, documentation, delivery information and self-service workflows in a consistent interface. The surrounding systems still perform their actual work: a deployment controller deploys, a source host stores repositories and a cloud provider provisions infrastructure.

This distinction matters when defining a feature. A deployment card might display status from an external controller. The card does not thereby become the controller or guarantee that the displayed information is current. The integration needs a source of truth, an identity with appropriate access and a clear handling of delayed or failed responses. A coherent portal experience depends on those contracts as well as the visual layout.

The software catalog provides a structured inventory of entities such as Components, APIs, Resources, Systems, Users and Groups. Relationships connect these entities so a developer can discover ownership and dependencies. The catalog is most useful when its metadata is maintained through trusted sources. A Component entity describing a service is not itself a running deployment, and a valid owner reference is not evidence that the owner is actively supporting it.

Software templates provide guided creation workflows. They can collect inputs and invoke approved actions to produce a repository or other starting artifacts. Their value is a repeatable supported path, not a promise that every future change remains compliant. Templates need input validation, suitable permissions and maintained actions. A generated project can drift after creation, so ongoing governance belongs to other controls and feedback mechanisms.

TechDocs supports publishing and discovering technical documentation associated with software. Documentation can improve onboarding and operation only if its ownership and update process are clear. A page that builds successfully can still contain obsolete guidance. The portal should make documentation easier to find while the responsible team maintains its technical accuracy.

Plugins extend these capabilities through browser features, backend functionality or both. A frontend plugin may provide pages and cards. A backend plugin may provide an API, scheduled work or privileged access to another system. Installing a package is only one step in assembling the feature. The application also needs its registration, configuration and any required integration permissions.

Consider a team adopting a portal to reduce time spent finding service owners. Its first useful scope might be a maintained catalog, organization identity data and owner-focused navigation. Adding ten unrelated plugins could increase complexity without improving that outcome. Framework flexibility makes selection possible, but it also places responsibility for a coherent user experience on the adopting team.

The organization operates the application as a product and a service. It chooses authentication, authorization, source integrations, database operation, secret delivery and availability expectations. It also maintains dependency upgrades and compatibility across plugins. A framework release does not automatically migrate every organization-specific extension or validate every external permission.

Responsibility should be visible at failure boundaries. If catalog ingestion fails, users need a way to distinguish missing metadata from a service outage. If a template action is denied, the response should explain the relevant permission without exposing credentials. Good integration design keeps these meanings clear rather than presenting every backend problem as an empty card.

## Common pitfalls

> [!WARNING]
> A portal is not the same thing as the infrastructure it presents. Valid catalog metadata does not prove runtime health, and installing a plugin does not complete its configuration or permission model. Choose features around user needs and assign ownership for their ongoing operation.
