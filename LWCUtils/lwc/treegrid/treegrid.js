import { LightningElement, api } from 'lwc';

export default class Treegrid extends LightningElement {
    @api columns;
    firstRender = true;
    @api keyField;
    @api treegridData;
    @api displayCustomTreegrid;

    @api expandAll() {
        this.template.querySelector('lightning-tree-grid').expandAll();
    }

    @api collapseAll() {
        this.template.querySelector('lightning-tree-grid').collapseAll();
    }

    renderedCallback() {
        if(this.firstRender) {
            console.log(this.template.querySelectorAll('a[href="https://#"]'));
            this.firstRender = false;
        }
    }
}