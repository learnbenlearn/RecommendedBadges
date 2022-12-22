#!/bin/env node

const util = require('util');
const exec = util.promisify(require('child_process').exec);

const ensurePackageIdsInPackageAliases = require('./ensurePackageIdsInPackageAliases.js');
const sortPackages = require('./sortPackages.js');
const {HUB_ALIAS, PACKAGE_DIRECTORIES, PACKAGE_ALIASES} = require('./constants.js');

async function getLatestPackageVersionIds() {
    let latestPackageVersionIds = {};
    for(let packageDirectory of PACKAGE_DIRECTORIES) {
        if(packageDirectory.package) {
            const {stdout, stderr} = await exec(
                `sfdx force:data:soql:query -q "SELECT SubscriberPackageVersionId FROM Package2Version WHERE Package2.Name='${packageDirectory.package}' ORDER BY MajorVersion DESC, MinorVersion DESC, PatchVersion DESC, BuildNumber DESC LIMIT 1" -t -u ${HUB_ALIAS} --json`
            );
            if(stderr) {
                process.stderr.write(`Error in getLatestPackageVersionIds(): ${stderr}`);
                process.exit(1);
            }

            latestPackageVersionIds[packageDirectory.package] = JSON.parse(stdout).result.records[0].SubscriberPackageVersionId;
        }
    }
    return latestPackageVersionIds;
}

async function getSortedPackagesToInstall() {
    await ensurePackageIdsInPackageAliases();
    let latestPackageVersionIds = await getLatestPackageVersionIds();

    let packages = new Set();
    for(let package in latestPackageVersionIds) {
        packages.add(package);
    }

    let sortedPackagesToInstall = await sortPackages(packages, PACKAGE_DIRECTORIES);
    for(let i in sortedPackagesToInstall) {
        sortedPackagesToInstall[i] = latestPackageVersionIds[sortedPackagesToInstall[i]];
    }

    process.stdout.write(`${Array.from(sortedPackagesToInstall).join(' ')}`)
}

module.exports.getSortedPackagesToInstall = getSortedPackagesToInstall;