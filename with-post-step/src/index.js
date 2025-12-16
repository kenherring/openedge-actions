// https://github.com/pyTooling/Actions/blob/main/with-post-step/main.js
// https://docs.github.com/en/actions/tutorials/create-actions/create-a-javascript-action#adding-actions-toolkit-packages

import * as core from "@actions/core";

const { spawn } = require("child_process")
const { appendFileSync } = require("fs")
const { EOL } = require("os")

function run(cmd) {
  console.log('starting cmd: ' + cmd)
  const subprocess = spawn(cmd, { stdio: "inherit", shell: true })
  subprocess.on("exit", (exitCode) => {
    process.exitCode = exitCode
  })
}

core.info(`Hello World!`);

const key = process.env.INPUT_KEY.toUpperCase()

if ( process.env[`STATE_${key}`] !== undefined ) { // Are we in the 'post' step?
  console.log('WE ARE IN THE POST STEP')
  run(process.env.INPUT_POST)
} else { // Otherwise, this is the main step
  console.log('WE ARE IN THE MAIN STEP (process.env.INPUT_MAIN=' + process.env.INPUT_MAIN + ')')
  if (process.env.INPUT_MAIN) {
    appendFileSync(process.env.GITHUB_STATE, `${key}=true${EOL}`)
    run(process.env.INPUT_MAIN)
  } else {
    console.log('skipping... INPUT_MAIN=undefined')
  }
}
