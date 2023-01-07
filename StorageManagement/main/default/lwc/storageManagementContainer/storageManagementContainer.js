import { LightningElement } from 'lwc';

import manualClean from '@salesforce/apex/StorageManagementController.invokeManualClean';

const SPINNER_TEXT = 'Clearing storage';

export default class StorageManagementContainer extends LightningElement {
    spinnerText = SPINNER_TEXT;

    async handleClearStorage() {
        try {
            await manualClean();
        } catch(err) {
            console.error(err);
        }
    }
}