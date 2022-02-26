import { LightningElement, api } from 'lwc';

export default class Treegrid extends LightningElement {
    @api columns;
    @api treegridData;
    @api keyField;

    @api expandAll() {
        this.template.querySelector('lightning-tree-grid').expandAll();
    }

    @api collapseAll() {
        this.template.querySelector('lightning-tree-grid').collapseAll();
    }
}