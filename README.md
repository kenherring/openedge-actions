# openedge-actions

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci_root.yml/badge.svg)

A collection of GitHub Actions simplifying CI/CD workflows for OpenEdge ABL projects

## Usage

* `kenherring/openedge-actions/setup` - install and configure OpenEdge
  * similar to [actions/setup-node](https://github.com/actions/setup-node)
* `kenherring/openedge-actions/run` - execute OpenEdge code
* `kenherring/openedge-actions/ablunit` - execute ABLUnit tests
* `kenherring/openedge-actions/database-start` - start an OpenEdge database server
<!--
* `kenherring/openedge-actions/database-stop` - stop an OpenEdge database server
-->

See [kenherring/openedge-actions-samples](https://github.com/kenherring/openedge-actions-samples) for advanced usage examples.

## Example Code

```yml
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:

      - uses: kenherring/openedge-actions/setup@v0
        with:
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          version: 12.8.9
          dlc: /psc/dlc

      - name: Run ABL Procedure
        id: run-procedure
        uses: kenherring/openedge-actions/setup@v0
        with:
          version: 12.8.9
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          startup-procedure: "src/my-procedure.p"

      - name: run ablunit
        id: run-ablunit
        uses: kenherring/openedge-actions/ablunit@v0
        with:
          version: 12.8.9 ## default=latest
          license: ${{ secrets.PROGRESS_CFG_LICENSE }} ## base64 encoded progress.cfg
          test-file-pattern: test/*.{cls,p} ## default=**/*.{cls,p}
```

## Action: `setup`

Install and configure openedge for use with later steps. By default the installation is cached for future runs.

```yml
    - uses: kenherring/openedge-actions/setup@v0
      with:
        license: ${{ secrets.PROGRESS_CFG_LICENSE }}
        version: 12.8.9
        dlc: /psc/dlc
```

### Inputs: `setup`

| Input          | Required | Default | Description                     |
| -------------- | -------- | ------- | ------------------------------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](#license-file)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `download-ade-source` | false | `true` | Download progress/ADE and add it to the propath when 'true' |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |

### Outputs: `setup`

| Output | Description |
| ------ | ----------- |
| `skipped` | A boolean value to indicate the ABL installation with matching version was already present at DLC |
| `cache-hit` | A boolean value to indicate if a cache was hit |
| `cache-saved` | description: A boolean value to indicate if the cache was saved |

## Action: `run`

Execute an OpenEdge source program. Automatically calls `setup` if DLC is not yet configured.

```yml
    - name: Run ABL Procedure
      id: run-procedure
      uses: kenherring/openedge-actions/run@v0
      with:
        version: 12.8.9
        license: ${{ secrets.PROGRESS_CFG_LICENSE }}
        startup-procedure: "src/my-procedure.p"
```

### Inputs: `run`

| Input          | Required | Default | Description                     |
| -------------- | -------- | ------- | ------------------------------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](#license-file1)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `download-ade-source` | false | `true` | Download progress/ADE and add it to the propath when 'true' |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |
| `working-directory` | false | | The working directory to run the procedure in |
| `propath` | false | `.` | Initial propath, set via PROPATH environment variable |
| `batch-mode` | false | `true` | Startup parameter -b |
| `startup-procedure` | true | | Startup parameter -p |
| `parameter-file` | false | | Startup parameter -pf |
| `temp-directory` | false | `$RUNNER_TEMP` | Startup parameter -T |
| `additional-parameters` | false | | Additional startup parameters |
| `parameter` | false | | Startup parameter -param |

## Action: `compile`

Compile OpenEdge code

## Sample

```yml
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - actions/checkout@v5
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
| `dest-dir` | false | | Directory where to put compiled code |
| `stop-on-error` | false | | If set to true, stop compilation as soon as an error occurs. |

<!--
## Outputs

TBD
-->

## Action: `ablunit`

Execute ablunit tests. Automatically calls `setup` if DLC is not yet configured.

```yml
    - name: run ablunit
      id: run-ablunit
      uses: kenherring/openedge-actions/ablunit@v0
      with:
        version: 12.8.9 ## default=latest
        license: ${{ secrets.PROGRESS_CFG_LICENSE }} ## base64 encoded progress.cfg
        test-file-pattern: test/*.{cls,p} ## default=**/*.{cls,p}
```

### Inputs: `ablunit`

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](#license-file)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |
| `working-directory` | false | | The working directory to run the tests in |
| `test-file-pattern` | false | `*.cls,**/*.cls,*.p,**/*.p` | Pattern to match ABLUnit test files |
| `startup-procedure` | false | `ABLUnitCore.p` | Startup parameter -p |
| `parameter-file` | false | | Startup parameter -pf |
| `temp-directory` | false | `$RUNNER_TEMP` | Startup parameter -T |
| `additional-parameters` | false | | Additional startup parameters |
| `ablunit-json` | false | `ablunit.json` | The ABLUnit configuration file, will be generated when not provided |

### Outputs: `ablunit`

| Output | Description |
| ------ | ----------- |
| `test-count` | total tests found |
| `failure-count` | tests failed |
| `error-count` | test with errors |
| `skipped-count` | tests skipped |

## Action: `database-start`

Start a database server

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
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](#license-file)</sup> |
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


## License File

Encode a license file using the following command, save the output as an actions secret, then configure with `license: ${secrets.MY_SECRET}`

```bash
base64 "$DLC/progress.cfg"
```

If your runner already has a license file available you can provide that path instead with `license: /path/to/progress.cfg`

## 🔗 Links

* [GitHub Docs - Workflow syntax for GitHub Actions](https://docs.github.com/en/actions/reference/workflows-and-actions/workflow-syntax)
* [DockerHub - progresssoftware](https://hub.docker.com/u/progresssoftware)
* [kenherring/ablunit-test-runner](https://github.com/kenherring/ablunit-test-runner)
