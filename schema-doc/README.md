# kenherring/openedge-actions/schema-doc

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci_schema_doc.yml/badge.svg)

Generate Schema Doc for OpenEdge database schema

## Sample

```yml
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: kenherring/openedge-actions/schema-doc@v0
        with:
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
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
| `artifact-name` | false | | Artifact name for uploading documentation |
| `db-name` | true | | Database name |
| `db-directory` | true | | Database directory |
| `file` | false | `schemadoc.xml` | XML file output |
| `text-file` | false | `doc/{db-name}.txt` | Text file output |
| `output-directory` | false | `doc/{db-name}` | Output directory |
| `gh-pages-branch` | false | `gh-pages` | GitHub Pages branch to push to |
