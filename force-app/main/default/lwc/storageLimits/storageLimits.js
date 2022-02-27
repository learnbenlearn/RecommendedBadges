import { LightningElement } from 'lwc';

import getStorageLimitInfo from '@salesforce/apex/StorageLimitsService.getStorageLimitInfo';

export default class StorageLimits extends LightningElement {
    cardTitle;
    displayCard;
    limitLabel = 'Limit';
    limitNum;
    percentConsumedLabel = 'Percent Consumed';
    percentConsumed;
    percentConsumedNum;
    valueLabel = 'Consumed';
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
}