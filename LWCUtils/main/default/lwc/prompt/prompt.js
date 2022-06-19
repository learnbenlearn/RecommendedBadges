import { LightningElement } from 'lwc';

export default class Prompt extends LightningElement {
    confirmDisabled = true;
    confirmLabel;
    handleConfirm;
    promptHeader;
}
