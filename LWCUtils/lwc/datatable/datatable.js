import { LightningElement, api } from 'lwc';

export default class Datatable extends LightningElement {
    @api columns;
    @api keyField;
    @api tableData;
    @api hasRowActions;

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;

        const actionClickEvent = new CustomEvent('actionclick', {
            detail: {
                action,
                row
            }
        });

        this.dispatchEvent(actionClickEvent);
    }
}