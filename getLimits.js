#!/bin/env node

const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function getLimits() {
    try {
        const {stdout, stderr} = await exec('sfdx force:limits:api:display --json');
        console.log(process.env.HUB_USER_NAME)
    } catch(err) {
        console.error(err);
    }
}

getLimits();