import { LightningElement, api, track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import deleteRecommendedBadge from '@salesforce/apex/BensViewService.deleteRecommendedBadge';
import getBensMixCategoryNames from '@salesforce/apex/BensViewService.getBensMixCategoryNames';
import getBensMixRecommendedBadges from '@salesforce/apex/BensViewService.getBensMixRecommendedBadges';

const ACTIONS = [
    {
        label: 'Delete Recommended Badge',
        name: 'delete'
    }
]

const HARDCODED_VIEW_OPTIONS = [
    {
        label: 'High Priority',
        value: 'High Priority'
    }
];

const TABLE_COLUMNS = [
    {
        label: 'Badge',
        fieldName: 'URL__c',
        type: 'url',
        typeAttributes: {
            label: {
                fieldName: 'Badge_Name__c'
            }
        }
    },
    {
        label: 'Type',
        fieldName: 'Type__c'
    },
    {
        label: 'Time Estimate',
        fieldName: 'Time_Estimate__c'
    },
    {
        type: 'action',
        typeAttributes: {
            rowActions: ACTIONS
        }
    }
]

export default class BensViewContainer extends LightningElement {
    @api divClasses;
    dropdownViewLabel = 'Select View';
    dropdownViewValue = 'High Priority';
    isLoading = true;
    recommendedBadgeData;
    tableColumns = TABLE_COLUMNS;
    @track tableData;
    viewOptions;

    async connectedCallback() {
        try {
            let mixCategoryData = await getBensMixCategoryNames(); 
            this.viewOptions = HARDCODED_VIEW_OPTIONS;

            for(let categoryName of mixCategoryData) {
                this.viewOptions.push({
                    label: categoryName,
                    value: categoryName
                });
            }

            this.recommendedBadgeData = await getBensMixRecommendedBadges();
            this.tableData = this.recommendedBadgeData[this.dropdownViewValue]
            this.isLoading = false;

        } catch(err) {
            console.error(err);
        }
    }

    handleDropdownChange(event) {
        this.tableData = this.recommendedBadgeData[event.detail];
    }

    async handleRowAction(event) {
        switch(event.detail.action.name) {
            case 'delete':
                this.isLoading = true;

                let deletedRowIndex;

                for(let row of this.tableData) {
                    if(row.Id === event.detail.row.Id) {
                        deletedRowIndex = this.tableData.indexOf(row);
                    }
                }

                try{
                    await deleteRecommendedBadge({recommendedBadgeId: event.detail.row.Id});
    
                    this.tableData = this.tableData.slice(0, deletedRowIndex).concat(this.tableData.slice(deletedRowIndex + 1));
                    
                    // special case when high priority
                    // update recommendedBadgeData
    
                    const showToastEvent = new ShowToastEvent({
                        title: 'Success',
                        message: 'Deleted ' + event.detail.row.Badge_Name__c + ' recommended badge.',
                        variant: 'success'
                    });
    
                    this.dispatchEvent(showToastEvent);
                } catch(err) {
                    console.error(err);
                }

                this.isLoading = false;
        }
    }
}