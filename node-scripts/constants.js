#!/bin/env node
const fs = require('fs');

const HUB_ALIAS = process.env.HUB_ALIAS || 'RecommendedBadges';
const SFDX_PROJECT_JSON = JSON.parse(fs.readFileSync('./sfdx-project.json'));
const PACKAGE_ALIASES = SFDX_PROJECT_JSON.packageAliases;
const PACKAGE_ALIAS_DELIMITER = '@';
const PACKAGE_DIRECTORIES = SFDX_PROJECT_JSON.packageDirectories;
const PACKAGE_ID_PREFIX = '0Ho';
const PACKAGE_VERSION_ID_PREFIX = '04t';
const REVERSE_PACKAGE_ALIASES = {};

for(let alias in PACKAGE_ALIASES) {
    REVERSE_PACKAGE_ALIASES[PACKAGE_ALIASES[alias]] = alias;
}

module.exports = {
    HUB_ALIAS,
    PACKAGE_ALIASES,
    PACKAGE_ALIAS_DELIMITER,
    PACKAGE_DIRECTORIES,
    PACKAGE_ID_PREFIX,
    PACKAGE_VERSION_ID_PREFIX,
    REVERSE_PACKAGE_ALIASES
};