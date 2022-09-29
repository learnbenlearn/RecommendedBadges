#!/bin/env node

const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function getLimits() {
    try {
        const {stdout, stderr} = await exec(`sfdx force:limits:api:display -u ${process.env.HUB_ALIAS} --json`);
        if(stderr) {
            console.log(stderr);
        } else {
            console.log(stdout.result);
        }
    } catch(err) {
        console.error(err);
    }
}

getLimits();