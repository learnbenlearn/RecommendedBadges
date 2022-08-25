const fs = require ('fs');

let sfdxProject = fs.readFileSync('sfdx-project.json');
let sfdxProjectJSON = JSON.parse(sfdxProject);
console.log(sfdxProjectJSON.packageAliases);