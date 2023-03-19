import { LightningElement, api } from 'lwc';

import getStorageLimitInfo from '@salesforce/apex/StorageLimitsController.getStorageLimitInfo';

const DATA_STORAGE_URL = '/lightning/setup/CompanyResourceDisk/home';

export default class StorageLimits extends LightningElement {
    cardTitle;
    dataStorageUrl = DATA_STORAGE_URL;
    displayCard;
    limitLabel = '<strong>Limit</strong>';
    limitNum;
    percentConsumedLabel = 'Percent Consumed';
    percentConsumed;
    percentConsumedNum;
    valueLabel = '<strong>Consumed</strong>';
    valueNum;

    connectedCallback() {
        this.fetchStorageLimitInfo();
    }

    async fetchStorageLimitInfo() {
        let storageLimitInfo = await getStorageLimitInfo();
        this.cardTitle = storageLimitInfo.Name;
        this.limitNum = storageLimitInfo.Limit;
        this.valueNum = storageLimitInfo.Value;
        this.percentConsumed = this.valueNum / this.limitNum;
        this.percentConsumedNum = parseInt((this.percentConsumed) * 100);

        this.displayCard = true;
    }

    @api refreshStorageLimitInfo() {
        this.fetchStorageLimitInfo();
    }
}