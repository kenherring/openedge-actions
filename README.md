# openedge-actions

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci.yml/badge.svg)

A collection of GitHub Actions simplifying CI/CD workflows for OpenEdge ABL projects

## Usage

* `kenherring/openedge-actions/setup` - install and configure OpenEdge
  * similar to [actions/setup-node](https://github.com/actions/setup-node)
* `kenherring/openedge-actions/run` - execute OpenEdge code
* `kenherring/openedge-actions/ablunit` - execute ABLUnit tests

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
        uses: kenherring/openedge-actions/ablunit@v1
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
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](#license-file1)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `download-ade-source` | false | `false` | Download progress/ADE and add it to the propath when 'true' (all other values evaluates to false) |
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
| `download-ade-source` | false | `false` | Download progress/ADE and add it to the propath when 'true' (all other values evaluates to false) |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |
| `working-directory` | false | | The working directory to run the procedure in |
| `propath` | false | `.` | Initial propath, set via PROPATH environment variable |
| `batch-mode` | false | `true` | Startup parameter -b |
| `startup-procedure` | true | | Startup parameter -p |
| `parameter-file` | false | | Startup parameter -pf |
| `temp-directory` | false | `$RUNNER_TEMP` | Startup parameter -T |
| `parameter` | false | | Startup parameter -param |

## Action: `ablunit`

Execute ablunit tests. Automatically calls `setup` if DLC is not yet configured.

```yml
    - name: run ablunit
      id: run-ablunit
      uses: kenherring/openedge-actions/ablunit@v1
      with:
        version: 12.8.9 ## default=latest
        license: ${{ secrets.PROGRESS_CFG_LICENSE }} ## base64 encoded progress.cfg
        test-file-pattern: test/*.{cls,p} ## default=**/*.{cls,p}
```

### Inputs: `ablunit`

| Input | Required | Default | Description |
| ----- | -------- | ------- | ----------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](#license-file1)</sup> |
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

### Outputs: `ablunit`

| Output | Description |
| ------ | ----------- |
| `test-count` | total tests found |
| `failure-count` | tests failed |
| `error-count` | test with errors |
| `skipped-count` | tests skipped |

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

<!--

* Tasks
  * Ensure ant & PCT are configured
  * Leverage `openedge-project.json` when possible
* Future Actions
  * `kenherring/openedge-actions/compile`
  * `kenherring/openedge-actions/database-create`
  * `kenherring/openedge-actions/database-start`
  * `kenherring/openedge-actions/pasoe-start`
  * `kenherring/openedeg-actions/sonarqube`
* kenherring/openedge-actions-samples - repo with sample projects
  * setup -> compile
  * setup -> ant compile (and other ANT tasks)
  * run
  * ablunit
  * ablunit - run tests against multiple OE versions with `matrix`
  * setup -> create database -> ablunit
  * setup -> create-database -> start-database -> run
-->
