# kenherring/openedge-actions/setup

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci_setup.yml/badge.svg)

GitHub Action to setup and cache OpenEdge ABL version and adds `$DLC/bin` to the `PATH`.

## Sample

```yml
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - uses: kenherring/openedge-actions/setup@v0
        with:
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          version: 12.8.9
```

## Usage

* `runs-on` must be a Linux runner with docker support

## Inputs

| Input          | Required | Default | Description                     |
| -------------- | -------- | ------- | ------------------------------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](../README.md#license-file)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `download-ade-source` | false | `false` | Download progress/ADE and add it to the propath when 'true' (all other values evaluates to false) |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |

## Outputs

| Output | Description |
| ------ | ----------- |
| `skipped` | A boolean value to indicate the ABL installation with matching version was already present at DLC |
| `cache-hit` | A boolean value to indicate if a cache was hit |
| `cache-saved` | description: A boolean value to indicate if the cache was saved |
