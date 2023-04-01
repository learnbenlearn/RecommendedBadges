import { LightningElement } from 'lwc';

import manualClean from '@salesforce/apex/StorageManagementController.invokeManualClean';

const SPINNER_TEXT = 'Clearing storage';

export default class StorageManagementContainer extends LightningElement {
    displaySpinner;
    spinnerText = SPINNER_TEXT;

    async handleClearStorage() {
        try {
            this.displaySpinner = true;
            await manualClean();
            this.displaySpinner = false;
        } catch(err) {
            this.template.querySelector('c-error').handleError(err);
        }
    }
}