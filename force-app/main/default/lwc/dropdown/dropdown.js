import { LightningElement, api } from 'lwc';

export default class Dropdown extends LightningElement {
    @api label;
    @api value;
    @api options;

    handleChange() {

    }
}