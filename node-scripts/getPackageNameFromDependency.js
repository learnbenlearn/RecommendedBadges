#!/bin/env node

const util = require('util');
const exec = util.promisify(require('child_process').exec);

const {HUB_ALIAS, PACKAGE_ALIAS_DELIMITER, PACKAGE_ID_PREFIX, PACKAGE_VERSION_ID_PREFIX, REVERSE_PACKAGE_ALIASES} = require('./constants.js');

async function getPackageNameFromDependency(dependentPackage) {
    let endIndex = dependentPackage.package.indexOf(PACKAGE_ALIAS_DELIMITER);
    if(endIndex == -1) {
        endIndex = dependentPackage.package.length;
    }

    if(dependentPackage.package.startsWith(PACKAGE_VERSION_ID_PREFIX) && Object.keys(REVERSE_PACKAGE_ALIASES).includes(dependentPackage.package)) {
        let alias = REVERSE_PACKAGE_ALIASES[dependentPackage.package];
        return alias.slice(0, alias.indexOf(PACKAGE_ALIAS_DELIMITER));
    } else if(dependentPackage.package.startsWith(PACKAGE_VERSION_ID_PREFIX)) {
        const {stderr, stdout} = await exec(
            `sfdx force:data:soql:query -q "SELECT Package2Id FROM Package2Version WHERE SubscriberPackageVersionId='${dependentPackage.package}'" -t -u ${HUB_ALIAS} --json`
        );
        if(stderr) {
            process.stderr.write(`Error in getPackageNameFromDependency(): ${stderr}`);
            process.exit(1);
        }
        let result = JSON.parse(stdout).result.records;
        if(result.length > 0 && REVERSE_PACKAGE_ALIASES[result[0].Package2Id]) {
            return REVERSE_PACKAGE_ALIASES[result[0].Package2Id];
        }
    } else if(dependentPackage.package.startsWith(PACKAGE_ID_PREFIX)) {
        return REVERSE_PACKAGE_ALIASES[dependentPackage.package];
    } else {
        return dependentPackage.package.slice(0, endIndex);
    }
}

module.exports = getPackageNameFromDependency;