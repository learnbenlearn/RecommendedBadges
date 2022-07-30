import { LightningElement, api, track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import deleteRecommendedBadge from '@salesforce/apex/BensViewService.deleteRecommendedBadge';

import addToRecommendedBadgeMix from '@salesforce/apex/BensViewService.addToRecommendedBadgeMix';
import getMixCategoryData from '@salesforce/apex/BensViewService.getMixCategoryData';
import getBensMixRecommendedBadges from '@salesforce/apex/BensViewService.getBensMixRecommendedBadges';

const ACTIONS = [
    {
        label: 'Delete Recommended Badge',
        name: 'Delete Recommended Badge'
    },
    {
        label: 'Add to Recommended Badge Mix',
        name: 'Add to Recommended Badge Mix'
    }
]

const HIGH_PRIORITY_OPTION = {
    label: 'High Priority',
    value: 'High Priority'
};

const HIGH_PRIORITY_PREFIX = 'HP';

const PROMPT_HEADER = 'Add to Recommended Badges Mix';

const LOOKUP_OBJECT_NAME = 'Mix Category';
const RESULT_ICON_NAME = 'custom:custom46';

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
    displayPrompt;
    dropdownViewLabel = 'Select View';
    dropdownViewValue = 'High Priority';
    isLoading = true;
    keyField = 'High_Priority_Id__c';
    lookupItems;
    lookupObjectName = LOOKUP_OBJECT_NAME;
    lookupResultIconName = RESULT_ICON_NAME;
    mixCategoryData;
    promptHeader = PROMPT_HEADER;
    promptIsLoading;
    @track recommendedBadgeData;
    selectedRecommendedBadge;
    tableColumns = TABLE_COLUMNS;
    @track tableData;
    viewOptions;

    async connectedCallback() {
        try {
            this.mixCategoryData = await getMixCategoryData();
            this.viewOptions = [];
            this.viewOptions.push(HIGH_PRIORITY_OPTION);

            for(let mixCategory of this.mixCategoryData) {
                if(mixCategory.Recommended_Badge_Mix__r.Private_Mix__c) {
                    this.viewOptions.push({
                        label: mixCategory.Name,
                        value: mixCategory.Name
                    });
                }
            }

            this.recommendedBadgeData = await getBensMixRecommendedBadges();
            this.tableData = this.recommendedBadgeData[this.dropdownViewValue]
            this.isLoading = false;

        } catch(err) {
            console.error(err);
        }
    }

    populateLookupItems() {
        this.lookupItems = [];
        for(let mixCategory of this.mixCategoryData) {
            this.lookupItems.push({
                Id: mixCategory.Id,
                Name: mixCategory.Name,
                SecondaryFieldValue: mixCategory.Recommended_Badge_Mix__r.Name,
                ParentId: mixCategory.Recommended_Badge_Mix__c
            });
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
            case 'Delete Recommended Badge':
                this.handleDelete(event.detail.row);
                break;
            case 'Add to Recommended Badge Mix':
                this.selectedRecommendedBadge = event.detail.row;
                this.populateLookupItems();
                this.displayPrompt = true;
                break;
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
            this.refreshRecommendedBadgeData();

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

    handlePromptClose() {
        this.displayPrompt = false;
    }

    async handlePromptConfirm() {
        this.promptIsLoading = true;
        let selectedMixCategory = this.template.querySelector('c-lookup').selectedItem;
        let recommendedBadge = {
            Id: this.selectedRecommendedBadge.Id,
            Mix_Category__c: selectedMixCategory.Id
        };

        try {
            await addToRecommendedBadgeMix({recommendedBadge: recommendedBadge});
            this.refreshRecommendedBadgeData(); 
            this.promptIsLoading = false;
            this.displayPrompt = false;

            const showToastEvent = new ShowToastEvent({
                title: 'Success',
                message: 'Changed Mix Category for ' + this.selectedRecommendedBadge.Badge_Name__c + ' to ' + selectedMixCategory.Name,
                variant: 'success'
            });
            this.dispatchEvent(showToastEvent);
        } catch(err) {
            console.error(err);
        }
    }

    async refreshRecommendedBadgeData() {
        this.recommendedBadgeData = await getBensMixRecommendedBadges();
        this.tableData = this.recommendedBadgeData[this.dropdownViewValue];
    }
}