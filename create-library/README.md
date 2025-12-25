# kenherring/openedge-actions/create-library

Create Procedure Library (.pl)

## Sample

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

## Inputs

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

<!--

## find replace notes for PCT functions

### Find

```text
(.*) \t(.*) \t(.*)
```

### Inputs

```text
pct-$1:\n  description: "$2"\n  required: false\n  default: "$3"
```

### Environment Variables

```text
PCT_$1: ${{ inputs.pct-$1 }}
```

### build.xml

```text
$1="${env.PCT_$1}"
```

-->
