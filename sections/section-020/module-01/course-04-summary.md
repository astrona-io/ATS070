---
draft: true
exam_objectives:
  - Configure Backstage
---
# Summary

A Backstage application reads its configuration at startup from YAML files. The file `app-config.yaml` is the base and is required unless `--config` flags are given. Other files add to it in a fixed order. When one or more `--config` flags are present, the default files are not loaded and the last flag has the highest priority. The paths are relative to the working directory of the process.

Merging is deep for objects and replacing for everything else. Two files that both set `backend.cors` combine their keys. A primitive value from the later source replaces the earlier one. An array from the later source replaces the whole earlier array, so a list is never extended by a second file. A `null` value means that the setting is explicitly absent.

Values can also come from outside the files. An environment variable named `APP_CONFIG_` plus the key path overrides a single value and has the highest priority of all sources. Its value is parsed as JSON and used as a plain string when parsing fails. Inside a file, `$env` reads an environment variable, `$file` reads a file as text and `$include` loads and parses another YAML or JSON file. The `${NAME}` form inside a string reads an environment variable too. These are resolved when the application starts, so a change needs a restart.

On Kubernetes the files normally come from ConfigMaps mounted into the pod, and the `--config` flags in the container arguments select and order them. A change to a ConfigMap does not reach the running Backstage process until the pod restarts.

Key facts:

- The base file is `app-config.yaml`; `app-config.local.yaml` has higher priority when no `--config` flag is given.
- Primitives and arrays are replaced; objects are merged deeply.
- `APP_CONFIG_` variables have the highest priority.
- Configuration is read at startup, so a new value needs a new process.

<!-- astrona:playground:destroy -->
