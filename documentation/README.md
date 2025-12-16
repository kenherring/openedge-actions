# kenherring/openedge-actions/documentation

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci_documentation.yml/badge.svg)

Generate Json Documentation for OpenEdge code

## Sample

```yml
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: kenherring/openedge-actions/documentation@v0
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
| `propath` | false | `.` | Initial propath, set via PROPATH environment variable |
| `artifact-name` | false | | Artifact name for uploading documentation |
| `skip-compile` | false | `false` | Skip compilation |
| `pct-destFile` | false | `documentation.json` | JSON file output |
| `pct-buildDir` | false | `.` | Directory where rcode will be read |
| `pct-encoding` | false | `None` | Use specific encoding when reading source files |
| `pct-style` | false | `Javadoc` | Comment style: Javadoc (/**), simple (/*), consultingwerk (/*-) |
| `pct-indent` | false | `false` | JSON pretty-printing |
