#!/bin/env node

const util = require('util');
const exec = util.promisify(require('child_process').exec);

const USERNAME = process.env.CIRCLE_USERNAME || 'learnbenlearn';
const REPO = process.env.CIRCLE_PROJECT_REPONAME || 'RecommendedBadges';
const PULL_REQUEST_NUMBER = process.env.CIRCLE_PULL_REQUEST ? process.env.CIRCLE_PULL_REQUEST.substring(process.env.CIRCLE_PULL_REQUEST.lastIndexOf('/')) : 115;


async function getPackageToggle() {
    try {
        const {stdout, stderr} = await exec(`gh api -H "Accept: application/vnd.github+json" /repos/${USERNAME}/${REPO}/pulls/${PULL_REQUEST_NUMBER}`);
        if(stderr) {
            console.log(stderr);
        } else {
            if(JSON.parse(stdout).labels.length != 0) {

            }
        }
    } catch(err) {
        console.error(err);
    }
}

getPackageToggle();