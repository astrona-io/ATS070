---
draft: true
exam_objectives:
- Understand Backstage client-server architecture
---
# Summary

The frontend renders the portal and calls APIs through client abstractions. Backend plugins implement server routes and privileged integrations. Discovery locates a service, authentication establishes identity, and authorization decides permitted actions; none replaces the others. Clear contracts for responses, loading, errors and absent data allow the interface to report meaningful states without exposing server credentials or trusting browser-side decisions.
