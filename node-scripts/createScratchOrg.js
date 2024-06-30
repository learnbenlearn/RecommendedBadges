#!/bin/env node
const util = require('util');
const exec = util.promisify(require('child_process').exec);

async function createScratchOrg() {
    ({stdout, stderr} = await exec(`sf org create scratch -f ${process.env.SCRATCH_ORG_DEFINITION_FILE} -v ${process.env.HUB_ALIAS} -d -a ${process.env.TEST_ORG_ALIAS} --no-track-source -w ${process.env.WAIT_TIME} -y 1`));
    
    process.stdout.write(`stderr ${stderr}`);
    process.stdout.write(`stdout ${stdout}`);
    if(stderr) {
        process.stderr.write(`Error in createScratchOrg(): ${stderr}`);
        process.exit(1);
    } else if(stdout) {
        process.stdout.write(`Created scratch org: ${stdout}`);
    }
}

module.exports.createScratchOrg = createScratchOrg;