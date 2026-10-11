---
draft: true
exam_objectives:
- Deploy Backstage to production
---
# Production Deployment, Persistence And Operational Boundaries

Deploying Backstage to production means operating an application with dependencies, rather than copying a browser bundle to a server. The deployment needs an application artifact, effective runtime configuration, authentication, authorization, database access and approved integrations. Its network entry points must route browser and API traffic correctly. Each of those contracts can fail independently and needs an identifiable operational owner.

The artifact should correspond to a reviewed source revision and dependency resolution. Reusing the same identified artifact across environments makes differences easier to attribute to configuration. Rebuilding separately for production creates another source of variation unless the build inputs and provenance are carefully controlled. A fixed image digest identifies content, while a moving tag can refer to different content at different times.

Persistent data must outlive application replacement where the installed plugins require it. A production database needs appropriate availability, backup and recovery design. Development-oriented local storage is not automatically suitable for multiple replicas or operational recovery. Database credentials should be delivered through the approved secret mechanism and limited to the authority the application needs.

Consider a portal with catalog processing and software-template history. Replacing an application Pod should not accidentally erase the durable records those features depend on. Conversely, preserving every temporary cache forever is unnecessary. The deployment design should distinguish durable state, reconstructible state and ephemeral process state. That distinction determines what needs backup and what can be regenerated from trusted sources.

Readiness and functional health also differ. A process can answer a basic health endpoint while an external source integration is unauthorized. A frontend can load while catalog processing is stalled. Useful operational evidence therefore covers the application process, database connectivity, processing freshness and critical user journeys at their relevant boundaries. One successful request is not a universal health guarantee.

Network configuration connects browser-visible addresses with backend routing. An ingress or reverse proxy may terminate TLS and forward requests to the application. The backend's external address, allowed origins and authentication callback configuration must agree with the intended deployment. A mismatch can produce a login failure even when the process itself is healthy. The response should be diagnosed as an identity or routing contract rather than a build error.

Scaling introduces coordination questions. Multiple backend replicas need compatible database access and appropriate behavior for scheduled tasks. The scheduler and plugin implementations determine how work is coordinated; simply doubling replicas does not guarantee useful parallelism. External systems may also impose request limits. A larger application fleet can increase load on those systems unless caching and scheduling are designed deliberately.

Release planning must consider database migrations and compatibility. A new application version can change durable schema or stored data. Returning to an earlier image may not restore an earlier database shape. Recovery should therefore account for artifact rollback, configuration rollback and data recovery separately. Those operations can have different costs and safety constraints.

Security continues beyond login. Server-side authorization must protect sensitive actions and data, while integration credentials remain outside browser assets and public catalog metadata. Logs should avoid leaking tokens or confidential request details. Upgrade planning should include the framework, plugins and base runtime because vulnerabilities and compatibility changes can cross all three.

The result is an operational service with documented expectations and clear failure ownership. A user should know whether an empty catalog is caused by source access, processing or a genuinely absent entity. Operators should have enough evidence to locate that failure without guessing from a generic homepage response.

## Common pitfalls

> [!WARNING]
> Do not treat an image build or a single health response as complete production readiness. Database migrations, persistent-data recovery, integration permissions and server-side authorization require their own design. Replica count alone does not solve coordination or external-service limits.
