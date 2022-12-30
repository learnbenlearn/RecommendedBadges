import { LightningElement, wire } from 'lwc';

import userId from '@salesforce/user/Id';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import PROFILE_NAME_FIELD from '@salesforce/schema/User.Profile.Name';

export default class Error extends LightningElement {
    @wire(getRecord, {recordId: userId, fields: [PROFILE_NAME_FIELD]})
    record;
    
    connectedCallback() {
        console.log(record.data);
    }
}