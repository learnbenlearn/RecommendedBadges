import { LightningElement, api } from 'lwc';

import getBensMixCategoryNames from '@salesforce/apex/BensViewService.getBensMixCategoryNames';
import getBensMixRecommendedBadges from '@salesforce/apex/BensViewService.getBensMixRecommendedBadges';

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
    }
]

export default class BensViewContainer extends LightningElement {
    @api divClasses;
    dropdownViewLabel = 'Select View';
    dropdownViewValue = 'High Priority';
    isLoading;
    recommendedBadgeData;
    tableColumns = TABLE_COLUMNS;
    tableData;
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
}