import { LightningElement, api } from 'lwc';

export default class LookupItem extends LightningElement {
    @api name;
    @api objectName;
    @api resultIconName;
    @api secondaryFieldValue;

    handleItemClick() {
        const itemClickEvent = new CustomEvent('itemclick', {
            detail: this.name
        });
        this.dispatchEvent(itemClickEvent);
    }
}