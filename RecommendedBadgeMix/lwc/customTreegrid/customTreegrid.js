import { LightningElement } from 'lwc';
import LightningTreeGrid from 'lightning/treeGrid'
import formattedRichTextTemplate from './formattedRichText.html';

export default class CustomTreegrid extends LightningTreeGrid {
    static customTypes = {
        formattedRichText: {
            template: formattedRichTextTemplate,
            standardCellLayout: true
        }
    }

    connectedCallback() {
        console.log(this.data);
        console.log(this.columns);
        console.log(this.keyField);
    }
}