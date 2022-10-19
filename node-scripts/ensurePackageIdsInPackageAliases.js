#!/bin/env node

const util = require('util');
const exec = util.promisify(require('child_process').exec);

const {HUB_ALIAS, PACKAGE_ALIASES, PACKAGE_DIRECTORIES} = require('./constants.js');

async function ensurePackageIdsInPackageAliases() {
    let packagesToQuery = [];
    for(let packageDirectory of PACKAGE_DIRECTORIES) {
        if(!Object.keys(PACKAGE_ALIASES).includes(packageDirectory.package) && packageDirectory.package) {
            packagesToQuery.push(packageDirectory.package);
        }
    }

    if(packagesToQuery.length > 0) {
        let queryConditionNames = packagesToQuery.map(x => '\'' + x + '\'').join(', ');
        const {stdout, stderr} = await exec(
            `sfdx force:data:soql:query -q "SELECT Id, Name FROM Package2 WHERE Name IN (${queryConditionNames})" -u ${HUB_ALIAS} -t --json`
        );
        if(stderr) {
            process.stderr.write(`Error in ensurePackageIdsInPackageAliases(): ${stderr}`);
            process.exit(1);
        } else {
            let queryResults = JSON.parse(stdout).result.records;
            for(let record of queryResults) {
                PACKAGE_ALIASES[record.Name] = record.Id;
            }
        }
    }
}

module.exports = ensurePackageIdsInPackageAliases;