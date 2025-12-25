# kenherring/openedge-actions/load-schema

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci_load_schema.yml/badge.svg)

Load openedge database schema, and create the database if it does not exist

## Sample

```yml
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: kenherring/openedge-actions/load-schema@v0
        with:
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          dest-file: my-schema.df
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
| `db-name` | true | | Database name |
| `db-dir` | false | `db` | Database directory |
| `dest-file` | false | `schema/{db-name}.df` | Schema file |
