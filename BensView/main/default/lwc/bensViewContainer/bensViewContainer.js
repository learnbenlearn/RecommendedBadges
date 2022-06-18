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

const HIGH_PRIORITY_OPTION = {
    label: 'High Priority',
    value: 'High Priority'
};

const HIGH_PRIORITY_PREFIX = 'HP';

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
    keyField = 'High_Priority_Id__c';
    @track recommendedBadgeData;
    tableColumns = TABLE_COLUMNS;
    @track tableData;
    viewOptions;

    async connectedCallback() {
        try {
            let mixCategoryData = await getBensMixCategoryNames(); 
            this.viewOptions = [];
            this.viewOptions.push(HIGH_PRIORITY_OPTION);

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
        if(event.detail === 'High Priority') {
            this.keyField = 'High_Priority_Id__c';
        } else {
            this.keyField = 'Id';
        }

        this.dropdownViewValue = event.detail;
        this.tableData = this.recommendedBadgeData[event.detail];
    }

    handleRowAction(event) {
        switch(event.detail.action.name) {
            case 'delete':
                this.handleDelete(event.detail.row);
        }
    }

    async handleDelete(rowToDelete) {
        this.isLoading = true;

        let recommendedBadgeId;

        if(this.dropdownViewValue === 'High Priority') {
            recommendedBadgeId = rowToDelete.Id.replace(HIGH_PRIORITY_PREFIX, '');
        } else {
            recommendedBadgeId = rowToDelete.Id;
        }

        try{
            await deleteRecommendedBadge({recommendedBadgeId: recommendedBadgeId});
            this.recommendedBadgeData = await getBensMixRecommendedBadges();
            this.tableData = this.recommendedBadgeData[this.dropdownViewValue];

            const showToastEvent = new ShowToastEvent({
                title: 'Success',
                message: 'Deleted ' + rowToDelete.Badge_Name__c + ' recommended badge.',
                variant: 'success'
            });

            this.dispatchEvent(showToastEvent);
        } catch(err) {
            console.error(err);
        }

        this.isLoading = false;
    }
}