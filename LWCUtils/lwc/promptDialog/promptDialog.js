import { LightningElement, api } from 'lwc';

export default class PromptDialog extends LightningElement {
    @api cancelLabel;
    @api displayCancel;
    @api confirmLabel;
    @api promptHeader;

    handleConfirm() {
        const confirmEvent = new CustomEvent('promptconfirm');
        this.dispatchEvent(confirmEvent);
    }

    handleCancel() {
        const cancelEvent = new CustomEvent('promptclose');
        this.dispatchEvent(cancelEvent);
    }
}