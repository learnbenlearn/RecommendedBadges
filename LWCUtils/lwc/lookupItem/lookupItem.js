/* eslint-disable one-var */
import { LightningElement, api } from 'lwc';

export default class LookupItem extends LightningElement {
    @api id;
    @api name;
    @api objectName;
    @api resultIconName;
    @api secondaryFieldValue;

    handleItemClick() {
        // eslint-disable-next-line no-magic-numbers
        const id = this.id.substring(0, this.id.lastIndexOf('-'));
        const itemClickEvent = new CustomEvent('itemclick', {
            bubbles: true,
            detail: {
                Id: id,
                Name: this.name,
            }
        });
        this.dispatchEvent(itemClickEvent);
    }
}