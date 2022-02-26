import { LightningElement, api } from 'lwc';

export default class Treegrid extends LightningElement {
    @api columns;
    @api treegridData;
    @api keyField;
}