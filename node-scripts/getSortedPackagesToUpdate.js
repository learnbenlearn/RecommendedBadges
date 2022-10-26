const util = require('util');
const exec = util.promisify(require('child_process').exec);

const sortPackages = require('./sortPackages.js');
const ensurePackageIdsInPackageAliases = require('./ensurePackageIdsInPackageAliases.js');
const getPackageNameFromDependency = require('./getPackageNameFromDependency.js');
const {PACKAGE_DIRECTORIES} = require('./constants.js');

const OUTPUT_FILENAME = '/tmp/artifacts/packagesToUpdate.txt';
// 598452d0fb1a3ff5e01cf5cb0be690817796e5f6
// b851edc4a777261f401611c03117e5b513c6a203

async function getChangedPackageDirectories() {
    let changedFiles = [];
    let changedPackageDirectories = new Set();
    try {
        const {stdout, stderr} = await exec('git diff HEAD^ --name-only');
        if(stderr) {
            process.stderr.write(`Error in getChangedPackageDirectories(): ${stderr}`);
            process.exit(1);
        }
        
        changedFiles = stdout.split('\n');
        for(let changedFile of changedFiles) {
            if(changedFile.indexOf('/') != -1) {
                changedPackageDirectories.add(changedFile.substring(0, changedFile.indexOf('/')));
            }
        }
    } catch(err) {
        console.error(err);
    }
    return changedPackageDirectories;
}

async function getPackagesToUpdate(changedPackageDirectories) {
    let packagesToUpdate = new Set();
    for(let packageDirectory of PACKAGE_DIRECTORIES) {
        if(changedPackageDirectories.has(packageDirectory.path) && packageDirectory.package) {
            packagesToUpdate.add(packageDirectory.package);
        }
    }

    for(let packageDirectory of PACKAGE_DIRECTORIES) {
        if(packageDirectory.dependencies) {
            for(let dependentPackage of packageDirectory.dependencies) {
                let packageName = await getPackageNameFromDependency(dependentPackage);
                if(packageName && packagesToUpdate.has(packageName)) {
                    packagesToUpdate.add(packageDirectory.package);
                }
            }
        }
    }
    return packagesToUpdate;
}

async function getSortedPackagesToUpdate() {
    let changedPackageDirectories = await getChangedPackageDirectories();
    await ensurePackageIdsInPackageAliases();
    let packagesToUpdate = await getPackagesToUpdate(changedPackageDirectories);
    let sortedPackagesToUpdate = await sortPackages(packagesToUpdate, PACKAGE_DIRECTORIES);
    process.stdout.write(sortedPackagesToUpdate.join(' '));
    fs.writeFileSync(OUTPUT_FILENAME, sortedPackagesToUpdate.join('\n'))
}

module.exports.getSortedPackagesToUpdate = getSortedPackagesToUpdate;