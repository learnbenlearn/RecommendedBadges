const axios = require('axios');

const HEROKU_ENDPOINT = 'https://recommended-badges-warehouse.herokuapp.com/job';
const PULL_REQUEST_URL = process.env.CIRCLE_PULL_REQUEST;

async function postToPackagingApp() {
    try {
        let pullRequestNumber = PULL_REQUEST_URL.substring(PULL_REQUEST_URL.lastIndexOf('/') + 1);
        const res = await axios.post(
            HEROKU_ENDPOINT,
            {
                pullRequestNumber,
            },
            {
                headers: {
                    'Token': process.env.GITHUB_SECRET
                }
            }
        );
        console.log(res.data);
    } catch(err) {
        process.stderr.write(`Error in postToPackagingApp(): ${err}`);
        process.exit(1);
    }
}

module.exports = {
    postToPackagingApp
};