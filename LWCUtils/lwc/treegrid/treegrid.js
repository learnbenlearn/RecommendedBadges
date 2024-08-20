import { LightningElement, api } from 'lwc';

export default class Treegrid extends LightningElement {
    @api columns;
    @api expandedRows;
    @api keyField;
    @api treegridData;
    @api displayCustomTreegrid;

    @api expandAll() {
        this.refs.treegrid.expandAll();
    }

    @api collapseAll() {
        this.refs.treegrid.collapseAll();
    }

    @api getCurrentExpandedRows() {
        return this.refs.treegrid.getCurrentExpandedRows();
    }
}