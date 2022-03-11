import { LightningElement, api } from 'lwc';

export default class Datatable extends LightningElement {
    @api columns;
    @api keyField;
    @api tableData;
}