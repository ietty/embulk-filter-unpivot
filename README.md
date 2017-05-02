# Unpivot filter plugin for Embulk

[Embulk](https://github.com/embulk/embulk/) filter plugin to nomalize fields.

## Overview

* **Plugin type**: filter

## Configuration

- **outer_key**: description (string, required)
- **inner_key**: description (string, required)
- **columns**: description (array, default: [])
- **additional**: description (array, default: [])

## Example

```yaml
filters:
  - type: unpivot
    option1: example1
    option2: example2
```


## Build

```
$ rake
```
