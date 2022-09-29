#!/bin/env node

const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function getLimits() {
    try {
        const {stdout, stderr} = await exec(`sfdx force:limits:api:display -u ${process.env.HUB_ALIAS} --json`);
        if(stderr) {
            console.log(stderr);
        } else {
            let jsonResponse = JSON.parse(stdout);
            let limitList = jsonResponse.result;
            console.log(limitList);
        }
    } catch(err) {
        console.error(err);
    }
}

getLimits();