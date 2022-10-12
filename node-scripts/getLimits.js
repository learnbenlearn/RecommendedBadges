#!/bin/env node

const util = require('util');
const exec = util.promisify(require('child_process').exec);

const SCRATCH_ORG_LIMIT = 'DailyScratchOrgs';
const PACKAGE_VERSION_LIMIT = 'Package2VersionCreates';
const PACKAGE_VERSION_NO_VALIDATION_LIMIT = 'Package2VersionCreatesWithoutValidation';

async function getLimits() {
    try {
        const {stdout, stderr} = await exec(`sfdx force:limits:api:display -u ${process.env.HUB_ALIAS} --json`);
        if(stderr) {
            console.log(stderr);
        } else {
            let jsonResponse = JSON.parse(stdout);
            let limitList = jsonResponse.result;
            let remainingScratchOrgs;
            let remainingPackageVersions;
            let remainingPackageVersionsNoValidation;

            for(let limit of limitList) {
                switch(limit.name) {
                    case SCRATCH_ORG_LIMIT:
                        remainingScratchOrgs = limit.remaining;
                        break;
                    case PACKAGE_VERSION_LIMIT:
                        remainingPackageVersions = limit.remaining;
                    case PACKAGE_VERSION_NO_VALIDATION_LIMIT:
                        remainingPackageVersionsNoValidation = limit.remaining;
                }
            }

            let limits = {
                "remaining-scratch-orgs": remainingScratchOrgs,
                "remaining-packages": remainingPackageVersions,
                "remaining-packages-without-validation": remainingPackageVersionsNoValidation
            }

            console.log(JSON.stringify(limits));

            process.stdout.write('test');
        }
    } catch(err) {
        console.log('here');
        console.error(err);
    }
}

module.exports = getLimits;