---
draft: true
exam_objectives:
  - Configure Backstage
---
# Section 020: Configure Backstage

This section teaches you to build the effective configuration of a Backstage application and to keep secrets out of it. You will see which files Backstage reads and in which order, how values merge, how environment variables override single values, which values reach the browser and how a secret travels from a Kubernetes Secret to the backend.

**Exam objective covered:** Configure Backstage

---

## What You Will Master

- Name the configuration files Backstage reads and predict which one wins when several set the same key.
- Predict the merged result for objects, primitive values, arrays and `null`.
- Use `APP_CONFIG_` variables and the `$env`, `$file`, `$include` and `${NAME}` substitutions.
- Explain what a `config.d.ts` schema declares and how typed readers behave.
- Decide which values are `frontend`, `backend` or `secret`.
- Deliver a secret through a Kubernetes Secret and rotate it.

---

## The Learning Path

### 1. Configuration Files, Merging And Overrides
*   **Module Reader:** **[Module 1: Configuration Files, Merging And Overrides](./module-01/course.md)**
*   **Hands-on Playground:** `sections/section-020/module-01/playground` - kind cluster with Backstage running from the public image and one mounted configuration file.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/module-01/playground
    ```
*   **Lab:** `sections/section-020/module-01/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/module-01/labs/lab-01
    astrona submit -c .
    ```

### 2. Visibility, Typing And Secret Boundaries
*   **Module Reader:** **[Module 2: Visibility, Typing And Secret Boundaries](./module-02/course.md)**
*   **Hands-on Playground:** `sections/section-020/module-02/playground` - kind cluster with Backstage running and a plain-text example token in its ConfigMap.
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/module-02/playground
    ```
*   **Lab:** `sections/section-020/module-02/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/module-02/labs/lab-01
    astrona submit -c .
    ```

### Section Capstone Challenge
*   **Comprehensive Challenge:** Configure Backstage Capstone - `sections/section-020/capstone/labs/lab-01` (UNTESTED)
    ```bash
    astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/capstone/labs/lab-01
    astrona submit -c .
    ```
*   **Hands-on Objective:** Move a leaked token into a Secret and refer to it with `${SCM_TOKEN}`, load a production overlay as the last `--config` flag and set `APP_CONFIG_app_title`. The grader checks live cluster state.

### Knowledge Check
*   **Quiz:** 10 questions in `sections/section-020/quiz.yaml`. The pass score is 70 percent.
