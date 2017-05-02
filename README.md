# Unpivot filter plugin for Embulk

[Embulk](https://github.com/embulk/embulk/) filter plugin to nomalize fields.

## Overview

* **Plugin type**: filter

## Configuration

- **outer_key**: normalization outer key field name(string, required)
- **inner_key**: inner key field name (string, required)
- **columns**: inner key key/value set (array, default: [])
- **additional**: additional field (array, default: [])

## Example




## Build

```
$ rake
```
