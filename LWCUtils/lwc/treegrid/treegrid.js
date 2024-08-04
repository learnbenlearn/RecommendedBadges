import { LightningElement, api } from 'lwc';

export default class Treegrid extends LightningElement {
    @api columns;
    @api keyField;
    @api treegridData;
    @api displayCustomTreegrid;

    @api expandAll() {
        this.template.querySelector('lightning-tree-grid').expandAll();
    }

    @api collapseAll() {
        this.template.querySelector('lightning-tree-grid').collapseAll();
    }
}