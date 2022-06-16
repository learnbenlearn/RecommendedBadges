import { LightningElement } from 'lwc';

import manualClean from '@salesforce/apex/StorageManagementService.manualClean';

export default class StorageManagementContainer extends LightningElement {
    handleClearStorage() {
        manualClean()
            .then(() => {
                this.template.querySelector('c-storage-limits').refreshStorageLimitInfo();
            })
            .catch(error => {
                console.error(error);
            });
    }
}