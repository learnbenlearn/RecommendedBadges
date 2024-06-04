import { LightningElement, api } from 'lwc';

export default class ColumnHeader extends LightningElement {
    @api fieldName;
    @api label;
    @api type;
}