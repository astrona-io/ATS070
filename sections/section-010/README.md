---
draft: true
exam_objectives:
- Understand the Backstage framework
---
# Section 010: Understand the Backstage framework

Makes the reader able to describe Backstage as a framework that an organization assembles into its own portal, to name the features it offers and the duties that stay with the adopting organization, and to read the anatomy of an application: the project packages, the backend system with plugins, modules, extension points and services, the frontend extensions, and the version rules that govern upgrades.

**Curriculum item covered:** Understand the Backstage framework

---

## What You Will Master

- Explain Backstage as an assembled developer portal framework and not as a finished product
- Distinguish catalog, templates, documentation, search and plugin integrations by what each one does and where its data comes from
- Identify what remains the responsibility of the adopting organization
- Name the standard packages of a Backstage project and the role of each one
- Explain how the backend system combines plugins, modules, extension points and services
- Explain how the frontend is built from extensions, and which version rules decide whether packages can run together

---

## The Learning Path

### 1. Framework Features, Integrations And Application Ownership
*   **Module Reader:** **[Module 1: Framework Features, Integrations And Application Ownership](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-01/playground` — kind cluster with the public Backstage image `1.55.2` in the namespace `backstage`, an in-memory SQLite database and a ConfigMap that holds the configuration layer.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/module-01/playground
    ```
*   **Lab:** Configure And Own The Portal — `sections/section-010/module-01/labs/lab-01`

### 2. Application Anatomy: Frontend, Backend And Plugins
*   **Module Reader:** **[Module 2: Application Anatomy: Frontend, Backend And Plugins](./module-02/course.md)**
*   **Hands-on Playground:** `sections/section-010/module-02/playground` — the same Backstage deployment, used to read the image layout, the installed backend plugins and the release.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/module-02/playground
    ```
*   **Lab:** Map The Application And Add A Configuration Layer — `sections/section-010/module-02/labs/lab-01`

### Section Capstone Challenge
*   **Comprehensive Challenge:** Understand the Backstage Framework Capstone — `sections/section-010/capstone/labs/lab-01`
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Repair a portal that does not start because its configuration layer is not mounted, set the title and the catalog rules, record the owner on the Deployment, and write down who owns the database, the identity and the upgrades. The grader checks the running pod, the Deployment arguments and the recorded responsibilities.

---

## Ready for Assessment?

*   **[Take the Section 010 Knowledge Check](./quiz.md)**
