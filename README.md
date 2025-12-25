# openedge-actions

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci_root.yml/badge.svg)

A collection of GitHub Actions simplifying CI/CD workflows for OpenEdge ABL projects

## Usage

* `kenherring/openedge-actions/setup` - install and configure OpenEdge
  * similar to [actions/setup-node](https://github.com/actions/setup-node)
* `kenherring/openedge-actions/run` - execute OpenEdge code
* `kenherring/openedge-actions/compile` - compile OpenEdge code
* `kenherring/openedge-actions/create-library` - create a procedure library (.pl)
* `kenherring/openedge-actions/ablunit` - execute ABLUnit tests
* `kenherring/openedge-actions/database-start` - start an OpenEdge database server
* `kenherring/openedge-actions/documentation` - generate json documentation
* `kenherring/openedge-actions/schema-doc` - generage scheme docs for database schema
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

      - uses: actions/checkout@v5

      - uses: kenherring/openedge-actions/setup@v0
        with:
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          version: 12.8.9
          dlc: /psc/dlc

      - name: Run ABL Procedure
        uses: kenherring/openedge-actions/setup@v0
        with:
          version: 12.8.9
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          startup-procedure: "src/my-procedure.p"

      - name: Run ABLUnit Tests
        uses: kenherring/openedge-actions/ablunit@v0
        with:
          version: 12.8.9 ## default=latest
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          test-file-pattern: test/*.cls,test/*.p
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

### Inputs: `compile`

| Input          | Required | Default | Description                     |
| -------------- | -------- | ------- | ------------------------------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](../README.md#license-file)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |
| `working-directory` | false | | The working directory to run the OpenEdge program in |
| `propath` | false | `.` | Initial propath, set via PROPATH environment variable |
| `artifact-name` | false | | Artifact name for uploading rcode |
| `pct-destDir` | false | `None` | Directory where to put compiled code |
| `pct-stopOnError` | false | `false` | If set to true, stop compilation as soon as an error occurs. |
| `pct-numThreads` | false | `1` | Starts n parallel compilation threads. Don't use multiple threads when compiling classes. |
| `pct-multiCompile` | false | `false` | Change COMPILER:MULTI-COMPILE attribute. |
| `pct-minSize` | false | `false` | Boolean value of MIN-SIZE option. |
| `pct-MD5` | false | `false` | Boolean value of GENERATE-MD5 option. |
| `pct-streamIO` | false | `false` | Boolean value of STREAM-IO option. |
| `pct-v6Frame` | false | `false` | Boolean value of V6FRAME option. |
| `pct-useUnderline` | false | `false` | USE-UNDERLINE option of V6FRAME |
| `pct-useRevVideo` | false | `false` | USE-REVVIDEO option of V6FRAME |
| `pct-runList` | false | `false` | true to generate a .run file for each compiled file, which summarizes RUN statements |
| `pct-listing` | false | `false` | Boolean value of LISTING option. Generated file name is identical to source file name, and is stored in xrefDir |
| `pct-listingSource` | false | `false` | Generates listing file from preprocessed source code (value preprocessor) or from standard source code (empty value or not defined). |
| `pct-preprocess` | false | `false` | Boolean value of PREPROCESSattribute. Generated file name appends .preprocess to source file name, and is stored in preprocessDir. |
| `pct-preprocessDir` | false | `<destDir>/.pct` | Target directory where preprocessed files are written. |
| `pct-debugListing` | false | `false` | Boolean value of DEBUG-LIST option. Generated file name appends .dbg to file name, and is stored in debugListingDir. |
| `pct-debugListingDir` | false | `destDir/.pct` | Target directory where debug listing files are written. |
| `pct-flattenDebugListing` | false | `true` | Flattens directory structure for debug listing files |
| `pct-stringXref` | false | `false` | Boolean value of STRING-XREFoption. Generated file name appends .strxref to source file name. |
| `pct-appendStringXref` | false | `false` | Appends STRING-XREF to a single file. |
| `pct-keepXref` | false | `false` | Keeps the generated XREF file for each file. Generated file name replaces extension of source file name with .xref. |
| `pct-noParse` | false | `false` | Always recompile, and skip XREF generation as well as .crc and .inc files. |
| `pct-xrefDir` | false | `<destDir>/.pct` | Target directory where PCT files (CRC, includes, preprocess, listing) will be created. |
| `pct-xmlXref` | false | `false` | Generates XREF in XML format. |
| `pct-forceCompile` | false | `false` | Always compile everything. |
| `pct-xcode` | false | `false` | Compiles using XCODE option. Disables XREF and LISTING options. |
| `pct-languages` | false | `None` | Comma-separated list of language segments to include in the compiled r-code. LANGUAGES option of the COMPILE statement |
| `pct-relativePaths` | false | `false` | Use relative paths instead of absolute paths for propath and filesets. Every fileset dir has to be in propath. |
| `pct-progPerc` | false | `0` (not displayed) | Show progression percentage every x percent. |
| `pct-displayFiles` | false | `0` (no display) | 1 will display files to be recompiled (and reason). 2 will display all files. 0 doesn't display anything |
| `pct-requireFullKeywords` | false | `false` | Strict-mode compiler option (11.7+). Output redirected to .warnings files in .pct directory |
| `pct-requireFullNames` | false | `false` | Strict-mode compiler option (11.7+). Output redirected to .warnings files in .pct directory |
| `pct-requireFieldQualifiers` | false | `false` | Strict-mode compiler option (11.7+). Output redirected to .warnings files in .pct directory |
| `pct-requireReturnValues` | false | `false` | Strict-mode compiler option (12.2+). Output redirected to .warnings files in .pct directory |
| `pct-outputType` | false | `console` | comma separated list of outputs |
| `pct-callbackClass` | false | `None` | Callback class (implementation of rssw.pct.AbstractCompileCallback) |

### Outputs: `compile`

| Output | Description |
| ------ | ----------- |
| `files-compiled` | Number of files compiled |
| `compile-errors` | Number of files that failed to compile |

## Action: `create-library`

Create Procedure Library (.pl)

```yml
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
      - uses: kenherring/openedge-actions/create-library@v0
        with:
          license: ${{ secrets.PROGRESS_CFG_LICENSE }}
          dest-dir: 'rcode'
          pct-destFile: my-library.pl
```

### Inputs: `create-library`

| Input          | Required | Default | Description                     |
| -------------- | -------- | ------- | ------------------------------- |
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](../README.md#license-file)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |
| `working-directory` | false | | The working directory to run the OpenEdge program in |
| `artifact-name` | false | | Artifact name for uploading procedure library |
| `pct-destFile` | false | `lib.pl` | R-code library to create |
| `pct-sharedFile` | false | | Memory mapped library to create |
| `pct-encoding` | false | | Character encoding used to store filenames. |
| `pct-noCompress` | false | `false` | Disable library compression. |
| `pct-cpInternal` | false | | Internal code page (-cpinternal parameter) |
| `pct-cpStream` | false | | Stream code page (-cpstream parameter) |
| `pct-cpColl` | false | | Collation table (-cpcoll parameter) |
| `pct-cpCase` | false | | Case table (-cpcase parameter) |
| `pct-basedir` | false | | The directory from which to store the files. |
| `pct-includes` | false | | Comma- or space-separated list of patterns of files that must be included. All files are included when omitted. |
| `pct-includesFile` | false | | The name of a file. Each line of this file is taken to be an include pattern. |
| `pct-excludes` | false | `**/*.pl` | Comma- or space-separated list of patterns of files that must be excluded. No files (except default excludes) are excluded when omitted. |
| `pct-excludesFile` | false | | The name of a file. Each line of this file is taken to be an exclude pattern. |
| `pct-defaultExcludes` | false | `true` | Indicates whether default excludes should be used or not ("yes"/"no"). Default excludes are used when omitted. |

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
| `license` | false | | Path to a license file or a secret value which is the base64 encoded license with newlines replaced with spaces <sup>[more info](../README.md#license-file)</sup> |
| `version` | false | `latest` | The ABL version to use |
| `dlc` | false | `/psc/dlc-${version}` | Target path for ABL installation, defaults to /psc/dlc-${version} |
| `cache-key` | false | calculated | An explicit key for a cache entry, or 'null' to disable caching |
| `cache-token` | false | | Value added to cache key, used to forcefully expire the cache if needed |
| `working-directory` | false | | The working directory to run the tests in |
| `propath` | false | `,` | Initial propath, set via PROPATH environment variable |
| `batch-mode` | false | `true` | Startup parameter -b |
| `startup-procedure` | false | `ABLUnitCore.p` | Startup parameter -p |
| `parameter-file` | false | | Startup parameter -pf |
| `temp-directory` | false | `$RUNNER_TEMP` | Startup parameter -T |
| `parameter` | false | | Startup parameter -param |
| `additional-parameters` | false | | Additional startup parameters |
| `test-file-pattern` | false | `*.cls,**/*.cls,*.p,**/*.p` | Pattern to match ABLUnit test files |
| `ablunit-json` | false | `ablunit.json` | The ABLUnit configuration file, will be generated when not provided |
| `debug` | false | `true` | Additional debug logging |

### Outputs: `ablunit`

| Output | Description |
| ------ | ----------- |
| `test-count` | total tests found |
| `failure-count` | tests failed |
| `error-count` | test with errors |
| `skipped-count` | tests skipped |

## Action: `database-start`

Start a database server

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

### Inputs: `database-start`

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

## Action: `documentation`

Generate Json Documentation for OpenEdge code

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

### Inputs: `documentation`

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
| `pct-style` | false | `Javadoc` | Comment style: Javadoc, simple, consultingwerk |
| `pct-indent` | false | `false` | JSON pretty-printing |

## Action: `schema-doc`

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci_schema_doc.yml/badge.svg)

Generate Schema Doc for OpenEdge database schema - [sports2000 example](https://kenherring.github.io/openedge-actions/doc/sp2k/sp2k.html)

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

### Inputs: `schema-doc`

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
