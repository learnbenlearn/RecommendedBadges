const axios = require('axios');

const HEROKU_ENDPOINT = 'https://recommended-badges-warehouse.herokuapp.com/job';
const PULL_REQUEST_NUMBER = process.env.CIRCLE_PULL_REQUEST;
const HEADER_PARAMETER_NAME = 'Token'

async function postToPackagingApp() {
    try {
        const res = await axios.post(
            HEROKU_ENDPOINT,
            {
                pullRequestNumber: PULL_REQUEST_NUMBER,
            },
            {
                headers: {
                    HEADER_PARAMETER_NAME: process.env.GITHUB_SECRET
                }
            }
        );
        process.stdout.write(res.data);
    } catch(err) {
        process.stderr.write(`Error in postToPackagingApp(): ${err}`);
        process.exit(1);
    }
}

postToPackagingApp();