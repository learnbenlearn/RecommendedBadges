import { LightningElement, wire } from 'lwc';

import getSetupData from '@salesforce/apex/RecommendedBadgeMixService.getSetupData';

export default class RecommendedBadgeMixContainer extends LightningElement {
    dropdownLabel = 'Select Badge Mix';
    dropdownOptions;
    dropdownValue;
    categoriesByMix;

    @wire(getSetupData)
    parseSetupData({error, data}) {
        if(data) {
            let options = [];
            for(let a of Object.keys(data.categoriesByMix)) {
                options.push({label: a, value: a});
            }
            this.dropdownOptions = options;

            this.categoriesByMix = data.categoriesByMix;
            this.dropdownValue = data.defaultMix;
        } else if(error) {
            console.error(error);
        }
    }

    handleDropdownChange() {
        
    }
}