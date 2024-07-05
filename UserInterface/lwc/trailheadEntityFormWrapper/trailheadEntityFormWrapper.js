import { LightningElement } from 'lwc';

const OPTIONS = [
    { label: 'Recommended Badge', value: 'Recommended_Badge__c' },
    { label: 'Recommended Trail', value: 'Recommended_Trail__c' }
];

export default class TrailheadEntityFormWrapper extends LightningElement {
    options = OPTIONS;
    _sObjectName;

    get sObjectName() {
        return this._sObjectName;
    }
    set sObjectName(value) {
        this._sObjectName = value;

        switch(value) {
            case 'Recommended_Badge__c':
                this.refs.badgeForm.classList.replace('slds-hide', 'slds-show');
                this.refs.trailForm.classList.replace('slds-show', 'slds-hide');
                break;
            case 'Recommended_Trail__c':
                this.refs.badgeForm.classList.replace('slds-show', 'slds-hide');
                this.refs.trailForm.classList.replace('slds-hide', 'slds-show');
                break;
        }
    }

    handleObjectChange(event) {
        this.sObjectName = event.detail.value;
    }
}