---
draft: true
exam_objectives:
- Understand the Backstage framework
---
# Catalog, Templates, TechDocs, Search And Integrations

A portal is useful only through the features it offers. Backstage has four core features that most organizations start with: the software catalog, software templates, TechDocs and search. A fifth idea, the integration, connects Backstage to the systems that own the real data. This part explains what each feature stores, which component does the work, and which setting controls it.

## The software catalog

The software catalog is the inventory of software that the portal knows. Each item in it is an entity, a record with a kind, a name, a namespace and a description of its relations. The common kinds are `Component` (a unit of software such as a service or a website), `API` (an interface that a component provides), `Resource` (infrastructure such as a database), `System` (a group of components that work together), `Domain` (a group of systems), `Group` and `User` (organization data) and `Location` (a pointer to more entity files).

Most entities come from a descriptor file. A descriptor is a YAML file, normally named `catalog-info.yaml`, that lives in the repository of the software it describes. The catalog backend reads the file from the location that the organization registered and stores the entities in its database. The descriptor below is an example of the format. It is read by the catalog backend from a repository. It is not applied with `kubectl`.

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: scout
  description: Reports the position of the fleet
  annotations:
    backstage.io/techdocs-ref: dir:.
spec:
  type: service
  lifecycle: production
  owner: group:default/bridge-crew
  system: starfleet
```

The field `spec.owner` is a reference to a `Group` or a `User` entity. The catalog stores the reference and checks it when it builds relations. It cannot prove that the owner still looks after the service. The field `spec.system` groups the component into a `System`. The annotation `backstage.io/techdocs-ref` tells TechDocs where the documentation of this component lives.

## Rules about which kinds the catalog accepts

The catalog has a setting that limits which entity kinds a source may add. The setting is `catalog.rules`, a list of rules in the configuration file. Each rule has an `allow` list of kinds. If the list does not contain a kind, the catalog rejects entities of that kind from locations that fall under the rule. This lets an organization allow `Component` and `API` entities everywhere, and accept `Template` entities only from a trusted location.

The catalog backend does the processing. It reads locations, validates entities, builds relations and stores the result. A validation failure shows up as an error on the entity or in the log of the backend, and the other entities continue to load.

## Software templates

A software template is an entity of kind `Template` that describes a guided workflow. The frontend renders a form from the template parameters. When the user submits the form, the scaffolder backend runs the steps of the template. A step is an action, for example fetching a skeleton project, publishing it to a repository, or registering the new component in the catalog.

The template decides what is created. The permissions of the backend decide whether the action may run, because the backend calls the source host with its own credentials. A template that creates a repository therefore needs an integration with a token that may create repositories. If the token is missing, the form works and the step fails. A template guarantees a good start only. It does not keep the new project in line with a standard after the first commit.

## TechDocs

TechDocs follows a docs-like-code approach. The documentation of a component is Markdown in the same repository as the code, together with an `mkdocs.yml` file. A build step turns the Markdown into static pages. TechDocs stores the result and the frontend displays it on the page of the entity, which the annotation `backstage.io/techdocs-ref` points to.

Backstage can build the pages itself in the backend, or an external pipeline can build them and publish them to a storage service. The second option moves the build away from the portal and is common in larger setups. In both cases the team that writes the Markdown owns the accuracy of the text. A page that builds without error can still describe a system that no longer exists.

## Search

Search lets users find entities and documents across the portal. A search backend collects documents from collectors, for example the catalog and TechDocs, and indexes them. The frontend sends a query to the search backend and shows the results. The search index is another derived copy of the data, so an entity can be in the catalog and still be missing from search until the next indexing run has finished.

## Integrations

An integration is the configuration that lets the backend talk to an external system, usually a source code host. It sits under the `integrations` key of the configuration file and holds the host name and, if needed, a token. Plugins read it and use it for their requests. Because the backend sends the requests, the token stays on the server side.

The configuration below shows the shape for a host. It is an example of the structure and is not applied in the playground. A real token is delivered as an environment variable and never written into the file.

```yaml
integrations:
  github:
    - host: github.com
      token: ${GITHUB_TOKEN}
```

The `${GITHUB_TOKEN}` form reads the value from an environment variable of the backend process when it starts. If the variable is missing, the backend stops with an error about the configuration instead of starting without the token.

## Change the catalog rules in the playground

The playground has a ConfigMap named `backstage-app-config` that holds the file `app-config.lab.yaml`. The next step adds a rule that allows only some entity kinds. Backstage reads configuration when the backend starts, so the pod must be restarted afterwards. Save the full ConfigMap as `configmap-backstage-app-config.yaml`:

<!-- astrona:playground:renew -->

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backstage-app-config
  namespace: backstage
data:
  app-config.lab.yaml: |
    app:
      title: Starfleet Portal
      baseUrl: http://localhost:7007
    organization:
      name: Starfleet
    backend:
      baseUrl: http://localhost:7007
      listen:
        port: 7007
      cors:
        origin: http://localhost:7007
      database:
        client: better-sqlite3
        connection: ':memory:'
    catalog:
      rules:
        - allow: [Component, System, API, Resource, Location]
```

Apply it:

```sh
kubectl apply -f configmap-backstage-app-config.yaml
```

Then restart the Deployment and wait until the new pod is ready. The mounted file changes in the existing pod after a short delay, but the backend does not read it again by itself, so the restart is what makes the setting active.

```sh
kubectl -n backstage rollout restart deployment/backstage
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

Check what the new pod sees. The command prints the mounted file, and the file must contain the `catalog` block.

```sh
kubectl -n backstage exec deployment/backstage -- cat /etc/backstage/app-config.lab.yaml
```

## What you now know

The catalog stores entities from descriptor files, templates run actions through the scaffolder backend, TechDocs turns Markdown into pages and search indexes data from other features. Integrations hold the credentials that the backend uses to reach external systems, and configuration decides which of these features accept which data. The open question is who, in the end, owns each of these decisions after the application goes live.

## Common pitfalls

> [!WARNING]
> A catalog entity describes software. It does not prove that the software runs, that the owner is active or that the documentation is correct. A template that works in the form can still fail in the backend when an integration token is missing. A changed configuration file has no effect until the backend process restarts.
