# Backstage Infrastructure (ATS070)

Certified Backstage Associate (CBA): Backstage Infrastructure, worth 22% of the official curriculum. This course belongs to ATP014.

Detailed lessons explain mechanisms, responsible components, examples and limits. Every module has a playground (a clean kind cluster with Backstage running) and a graded lab. Every section has a capstone lab and a knowledge check, and a final knowledge check closes the course. Labs run Backstage from the public image `ghcr.io/backstage/backstage:1.55.2` on kind (Kubernetes 1.35). Labs and playgrounds are built untested: only static checks were run. Technical content remains draft.

## Course Outline

| Section | Module | Hands-on |
| --- | --- | --- |
| 010 | 01 Framework Features, Integrations And Application Ownership | playground, lab |
| 010 | 02 Application Anatomy: Frontend, Backend And Plugins | playground, lab |
| 020 | 01 Configuration Files, Merging And Overrides | playground, lab |
| 020 | 02 Visibility, Typing And Secret Boundaries | playground, lab |
| 030 | 01 Packaging, Persistence And Database | playground, lab |
| 030 | 02 Running On Kubernetes: Secrets, Probes And Releases | playground, lab |
| 040 | 01 Frontend, Backend And Service Discovery | playground, lab |
| 040 | 02 Authentication, Authorization And Trust Boundaries | playground, lab |

Each section ends with a capstone lab and `quiz.yaml`. `sections/final-domain-quiz.yaml` closes the course.

## Author Review

See [curriculum coverage](CURRICULUM.md), [primary sources](SOURCES.md) and [contribution instructions](CONTRIBUTING.md). No runtime execution is claimed.
