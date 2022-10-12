#!/bin/env node

const fs = require('fs');

const getLimits = require('./getLimits.js');
const getPackageToggle = require('./getPackageToggle.js');

const OUTPUT_FILENAME = 'parameters.json';

async function populateParameters() {
    let limits = await getLimits();
    console.log(limits);
    //let parameters = JSON.parse(limits);
    //ßparameters["create-packages"] = await getPackageToggle();

    fs.writeFileSync(OUTPUT_FILENAME, parameters);
}

module.exports.populateParameters = populateParameters;