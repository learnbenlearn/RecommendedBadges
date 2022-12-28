import { LightningElement, api } from 'lwc';

export default class LookupItem extends LightningElement {
    @api id;
    @api name;
    @api objectName;
    @api resultIconName;
    @api secondaryFieldValue;

    handleItemClick() {
        let id = this.id.substring(0, this.id.indexOf('-'));
        const itemClickEvent = new CustomEvent('itemclick', {
            bubbles: true,
            detail: {
                Id: id,
                Name: this.name
            }
        });
        this.dispatchEvent(itemClickEvent);
    }
}