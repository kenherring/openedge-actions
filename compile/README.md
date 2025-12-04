# kenherring/openedge-actions/run

![CI](https://github.com/kenherring/openedge-actions/actions/workflows/ci_compile.yml/badge.svg)

Compile OpenEdge code

## Sample

```yml
jobs:
  my-job:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v5
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
| `pct-xcodeKey` | false | `None` | Sets specific key for encrypted procedures. Deprecated: use XCodeSessionKey attribute in PCTRun |
| `pct-languages` | false | `None` | Comma-separated list of language segments to include in the compiled r-code. LANGUAGES option of the COMPILE statement |
| `pct-textGrowth` | false | `None` | TEXT-SEG-GROWTH option of the COMPILE statement. |
| `pct-relativePaths` | false | `false` | Use relative paths instead of absolute paths for propath and filesets. Every fileset dir has to be in propath. |
| `pct-progPerc` | false | `0` (not displayed) | Show progression percentage every x percent. |
| `pct-displayFiles` | false | `0` (no display) | 1 will display files to be recompiled (and reason). 2 will display all files. 0 doesn't display anything |
| `pct-requireFullKeywords` | false | `false` | Strict-mode compiler option (11.7+). Output redirected to .warnings files in .pct directory |
| `pct-requireFullNames` | false | `false` | Strict-mode compiler option (11.7+). Output redirected to .warnings files in .pct directory |
| `pct-requireFieldQualifiers` | false | `false` | Strict-mode compiler option (11.7+). Output redirected to .warnings files in .pct directory |
| `pct-requireReturnValues` | false | `false` | Strict-mode compiler option (12.2+). Output redirected to .warnings files in .pct directory |
| `pct-outputType` | false | `console` | comma separated list of outputs |
| `pct-callbackClass` | false | `None` | Callback class (implementation of rssw.pct.AbstractCompileCallback) |

## Outputs

| Output | Description |
| ------ | ----------- |
| `files-compiled` | Number of files compiled |
| `compile-errors` | Number of files that failed to compile |

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
