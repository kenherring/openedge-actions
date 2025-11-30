# kherring/openedge-action/ablunit

![CI](https://github.com/kenherring/opendge-actions/actions/workflows/ci_ablunit.yml/badge.svg)

GitHub Action that executes ABLUnit tests

## Sample

```yml
jobs:
  my-job:
    name: run ablunit tests
    runs-on: ubuntu-latest
    steps:
      - name: run ablunit
        id: run-ablunit
        uses: kenherring/openedge-actions/ablunit@v1
        with:
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          test-file-pattern: test/*.{cls,p}
```

## Inputs

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](../README.md#license-file)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |
| `working-directory` | false | | The working directory to run the tests in |
| `test-file-pattern` | false | `*.cls,**/*.cls,*.p,**/*.p` | Pattern to match ABLUnit test files |
| `startup-procedure` | false | `ABLUnitCore.p` | Startup parameter -p |
| `parameter-file` | false | | Startup parameter -pf |
| `temp-directory` | false | `$RUNNER_TEMP` | Startup parameter -T |
| `ablunit-json` | false | `ablunit.json` | The ABLUnit configuration file, will be generated when not provided |

## Outputs

| Output | Description |
| ------ | ----------- |
| `test-count` | total tests found |
| `failure-count` | tests failed |
| `error-count` | test with errors |
| `skipped-count` | tests skipped |
