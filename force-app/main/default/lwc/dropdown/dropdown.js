import { LightningElement, api } from 'lwc';

export default class Dropdown extends LightningElement {
    @api label;
    @api value;
    @api options;

    handleChange() {
        

        console.log('here in dropdown');
        const changeEvent = new CustomEvent('dropdownchange', {
            detail: this.template.querySelector('lightning-combobox').value
        });

        this.dispatchEvent(changeEvent);
    }
}