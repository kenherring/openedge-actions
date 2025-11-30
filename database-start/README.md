# kherring/openedge-action/database-start

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci_database_start.yml/badge.svg)

GitHub Action that executes ABLUnit tests

## Sample

```yml
jobs:
  my-job:
    name: my-database-job
    runs-on: ubuntu-latest
    steps:
      - uses: kenherring/openedge-actions/database-start@v0
        with:
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          path: target/db/sp2k
          port: 2000
          minport: 3000
          maxport: 3100
```

## Inputs

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](../README.md#license-file)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |
| `working-directory` | false | | The working directory to run with |
| `path` | true | | Database path |
| `port` | false | `20931` | Database port |
| `minport` | false | `0` | Minimum port number for the database server |
| `maxport` | false | `0` | Maximum port number for the database server |
| `parameter-file` | false | | Startup parameter -pf |
| `additional-parameters` | false | | Additional database startup parameters |
