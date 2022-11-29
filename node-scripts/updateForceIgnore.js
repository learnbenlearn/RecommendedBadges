#!/bin/env node

const fs = require('fs');

const { PACKAGE_DIRECTORIES } = require('./constants.js');

const FORCE_IGNORE_FILENAME = '.forceignore';

function updateForceIgnore() {
    let sourceDirectories = [];
    for(let packageDirectory of PACKAGE_DIRECTORIES) {
        sourceDirectories.push(packageDirectory.path);
    }

    let forceIgnore = fs.readFileSync(FORCE_IGNORE_FILENAME, {encoding: 'utf8'});
    let forceIgnoreLines = forceIgnore.split('\n');
    for(let i in forceIgnoreLines) {
        if(sourceDirectories.includes(forceIgnoreLines[i]) && (forceIgnoreLines[i].indexOf('#') == -1)) {
            forceIgnoreLines[i] = '#' + forceIgnoreLines[i];
        }
    }
    try {
        fs.writeFileSync(FORCE_IGNORE_FILENAME, forceIgnoreLines.join('\n'));
    } catch(err) {
        console.log(err);
    }
}

module.exports.updateForceIgnore = updateForceIgnore;