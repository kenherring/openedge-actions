# kenherring/openedge-actions/run

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci_compile.yml/badge.svg)

Compile OpenEdge code

## Sample

```yml
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: kenherring/openedge-actions/compile@v0
        with:
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          dest-dir: 'rcode'
          stop-on-error: true
```

## Inputs

| Input          | Required | Default | Description                     |
| -------------- | -------- | ------- | ------------------------------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](../README.md#license-file)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |
| `working-directory` | false | | The working directory to run the OpenEdge program in |
| `propath` | false | `.` | Initial propath, set via PROPATH environment variable |
<!--
| `artifact-name` | false | | Upload the dest-dir as an artifact |
-->
| `dest-dir` | false | | Directory where to put compiled code |
| `stop-on-error` | false | | If set to true, stop compilation as soon as an error occurs. |
