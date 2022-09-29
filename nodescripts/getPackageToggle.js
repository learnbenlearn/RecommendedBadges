#!/bin/env node

const util = require('util');
const exec = util.promisify(require('child_process').exec);

const USERNAME = process.env.CIRCLE_USERNAME || 'learnbenlearn';
const REPO = process.env.CIRCLE_PROJECT_REPONAME || 'RecommendedBadges';
const PULL_REQUEST_NUMBER = process.env.CIRCLE_PULL_REQUEST ? process.env.CIRCLE_PULL_REQUEST.substring(process.env.CIRCLE_PULL_REQUEST.lastIndexOf('/')) : 115;
const PACKAGE_LABEL = "create packages";


async function getPackageToggle() {
    try {
        const {stdout, stderr} = await exec(`gh api -H "Accept: application/vnd.github+json" /repos/${USERNAME}/${REPO}/pulls/${PULL_REQUEST_NUMBER}`);
        if(stderr) {
            console.log(stderr);
        } else {
            let labels = JSON.parse(stdout).labels;
            if(labels.length != 0) {
                for(let label of labels) {
                    if(label.name === PACKAGE_LABEL) {
                        process.stdout.write(label.name);
                    }
                }
            }
        }
    } catch(err) {
        console.error(err);
    }
}

getPackageToggle();