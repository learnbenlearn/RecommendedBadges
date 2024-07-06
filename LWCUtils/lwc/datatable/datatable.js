/* eslint-disable one-var */
import { LightningElement, api } from 'lwc';

export default class Datatable extends LightningElement {
    @api columns;
    @api keyField;
    @api tableData;
    @api hasRowActions;

    handleRowAction(event) {
        const { action, row } = event.detail;

        const actionClickEvent = new CustomEvent('actionclick', {
            detail: {
                action,
                row
            }
        });

        this.dispatchEvent(actionClickEvent);
    }
}