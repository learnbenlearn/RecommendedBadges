const fs = require ('fs');

let sfdxProject = fs.readFileSync('sfdx-project.json');
let packageAliases = JSON.parse(sfdxProject).packageAliases;

let packages = Object.keys(packageAliases).filter((alias) => {
    return !alias.includes('@');
});

let latestVersions = [];

for(let package of packages) {
    let versionAliases = Object.keys(packageAliases).filter((alias) => {
        return alias.includes(package + '@');
    });

    latestVersions.push(findLatestVersion(versionAliases, package));
}

function findLatestVersion(versionAliases, packageName) {
    versionAliases = versionAliases.map((element) => {
        return element.replace(packageName + '@', '');
    });

    let latestVersion;
    for(let versionAlias of versionAliases) {
        if(!latestVersion) {
            latestVersion = versionAlias;
        } else {
            for(let index = 0; index <= 6; index+=2) {
                if(versionAlias[index] > latestVersion[index]) {
                    latestVersion = versionAlias;
                    break;
                } else if(versionAlias[index] < latestVersion[index]) {
                    break;
                }
            }
        }
    }

    return packageName + '@' + latestVersion;
}