import { LightningElement, api } from 'lwc';

export default class Treegrid extends LightningElement {
    @api columns;
    @api treegridData;
    @api keyField;
    @api displayCustomTreegrid;

    @api expandAll() {
        this.template.querySelector('lightning-tree-grid').expandAll();
    }

    @api collapseAll() {
        this.template.querySelector('lightning-tree-grid').collapseAll();
    }

    /*
        .slds-table thead th{
            background-color:var(--slds-g-color-neutral-base-95, #f3f3f3);
            color:var(--slds-g-color-neutral-base-30, #444444);
            padding:0.25rem 0.5rem;
            font-weight:700;
            line-height:normal;
        }
    */
}