import { LightningElement, wire } from 'lwc';

import getSetupData from '@salesforce/apex/RecommendedBadgeMixService.getSetupData';

export default class RecommendedBadgeMixContainer extends LightningElement {
    randomBool;

    @wire(getSetupData)
    parseSetupData({error, data}) {
        if(data) {
            console.log(data);
            this.randomBool = true;
        } else if(error) {
            console.error(error);
        }
    }
    



   // <c-dropdown label={dropdownLabel} value={dropdownValue} options={dropdownOptions}>
    /*

    export default class ComboboxBasic extends LightningElement {
        value = 'inProgress';
    
        get options() {
            return [
                { label: 'New', value: 'new' },
                { label: 'In Progress', value: 'inProgress' },
                { label: 'Finished', value: 'finished' },
            ];
        }
        <lightning-combobox label={label} value={value} options={options} onchange={handleChange}>
        </lightning-combobox>    
        */
}