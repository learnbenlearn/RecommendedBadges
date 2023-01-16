const axios = require('axios');
const fs = require('fs');

const HEROKU_ENDPOINT = 'https://recommended-badges-warehouse.herokuapp.com/job';
const SORTED_PACKAGES_TO_UPDATE_FILE = '/tmp/artifacts/packagesToUpdate.txt';
const PULL_REQUEST_URL = process.env.CIRCLE_PULL_REQUEST;

async function postToPackagingApp() {
    try {
        let pullRequestNumber = PULL_REQUEST_URL.substring(PULL_REQUEST_URL.lastIndexOf('/') + 1);
        let sortedPackagesToUpdate = fs.readFileSync(SORTED_PACKAGES_TO_UPDATE_FILE).split('\n');
        const res = await axios.post(
            HEROKU_ENDPOINT,
            {
                pullRequestNumber,
                jobNumber: process.env.CIRCLE_BUILD_NUM,
                sortedPackagesToUpdate
            },
            {
                headers: {
                    'Token': process.env.GITHUB_SECRET
                }
            }
        );
        console.log(`Job ID: ${res.data}`);
    } catch(err) {
        process.stderr.write(`Error in postToPackagingApp(): ${err}`);
        process.exit(1);
    }
}

module.exports = {
    postToPackagingApp
};