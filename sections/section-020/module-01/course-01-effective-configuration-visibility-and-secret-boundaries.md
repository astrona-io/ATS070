---
draft: true
exam_objectives:
- Configure Backstage
---
# Effective Configuration, Visibility And Secret Boundaries

Backstage configuration supplies application and plugin settings independently of source implementation. A project commonly has a shared application configuration and selected local or production overrides. The application loads the configured sources and merges them into an effective result. Installed packages then consume values using the configuration API and the schemas associated with their features.

The effective result matters more than any individual file. If a shared source defines a backend address and a higher-priority source replaces it, the running application uses the replacement. Nested objects can merge, while arrays and primitive values are replaced rather than simply accumulated. A null value can deliberately remove a value from the effective configuration. These rules explain why adding an override can unexpectedly remove a list of integrations or locations.

Suppose the shared configuration lists two catalog locations. A production override supplies a different locations array containing one entry. Treating the override as an append would lead an author to expect three locations. Replacement instead leaves the selected production array. That is a configuration interpretation problem, not a catalog processor failure. Reading the effective configuration separates the two possibilities before examining remote access.

Plugins use namespaced keys to define their inputs. Typed accessors such as a required string getter express what the plugin expects. A missing required setting can stop initialization, while an optional setting may fall back to defined behavior. The application's configuration schema can detect invalid shapes and unknown settings under the selected checks. A syntactically valid YAML document does not establish that it satisfies every installed plugin's contract.

Visibility is a critical security boundary. Backend code can receive settings that must not be delivered to the browser. Frontend visibility is declared through configuration schemas so the browser receives only intended values. A server integration token should never become browser-visible merely because a card needs to call that integration. The card should call an authorized backend API that handles the credential on the server.

Environment variables can supply overrides or values referenced by configuration. They are deployment inputs with their own validation and secret-handling requirements. A misspelled variable can leave a required setting unresolved. A variable placed in a build environment can also become embedded in browser assets if the configuration path exposes it there. The phrase environment variable does not automatically imply that a value remains secret.

External source references and substitutions need controlled inputs. Configuration may include mechanisms for reading values from environment or files, depending on the selected loader and package support. The resolved value must have the type expected by its consumer. A credential file with unexpected whitespace or a missing mount can create a different failure from an unauthorized token, even though both may appear during startup.

Configuration should be reviewed with the application's installed feature set. A key used by a removed plugin may no longer have a consumer. A newly installed plugin may require a schema and server setting absent from the deployment. Release-specific defaults also matter: copied configuration from another architecture can look plausible while targeting a different initialization path.

Finally, distinguish validation from operation. A configuration checker can establish that selected inputs satisfy known schemas. It cannot prove that a database accepts the configured identity or that a source provider allows a requested repository. Those behaviors require separate evidence. Keeping the boundaries explicit makes errors actionable and prevents a clean configuration report from being interpreted as complete production readiness.

## Common pitfalls

> [!WARNING]
> Do not expose server credentials through frontend-visible configuration. Review the merged result, especially replaced arrays and removed values. Schema validity establishes a configuration contract; external connectivity and permissions remain separate contracts.
