import { LightningElement } from 'lwc';

import manualClean from '@salesforce/apex/StorageManagementController.invokeManualClean';

export default class StorageManagementContainer extends LightningElement {
    // why is this handled by promises? doesn't seem like anything else is? change to async/await
    async handleClearStorage() {
        try {
            await manualClean();
            this.template.querySelector('c-storage-limits').refreshStorageLimitInfo();
        } catch(err) {
            console.error(err);
        }
    }
}