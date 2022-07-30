import { LightningElement, api } from 'lwc';

export default class Prompt extends LightningElement {
    @api confirmDisabled = false;
    @api confirmLabel;
    @api handleConfirm;
    @api promptHeader;
}
