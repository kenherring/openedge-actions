# kenherring/openedge-actions/run

![CI](https://github.com/kenherring/opendge-actions/actions/workflows/ci_run.yml/badge.svg)

GitHub Action that executes an OpenEdge procedure

## Sample

```yml
jobs:
  my-job:
    name: run openedge procedure
    runs-on: ubuntu-latest
    steps:
      - name: Run ABL Procedure
        id: run-procedure
        uses: kenherring/openedge-actions/run@v0
        with:
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          startup-procedure: "src/my-procedure.p"
```

## Inputs

| Input          | Required | Default | Description                     |
| -------------- | -------- | ------- | ------------------------------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](../README.md#license-file)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `download-ade-source` | false | `false` | Download progress/ADE and add it to the propath when 'true' (all other values evaluates to false) |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |
| `working-directory` | false | | The working directory to run the OpenEdge program in |
| `propath` | false | `.` | Initial propath, set via PROPATH environment variable |
| `batch-mode` | false | `true` | Startup parameter -b |
| `startup-procedure` | true | | Startup parameter -p |
| `parameter-file` | false | | Startup parameter -pf |
| `temp-directory` | false | `$RUNNER_TEMP` | Startup parameter -T |
| `parameter` | false | | Startup parameter -param |
