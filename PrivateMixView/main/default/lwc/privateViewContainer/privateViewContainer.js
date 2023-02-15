import { LightningElement, api, track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { deleteRecord, updateRecord } from 'lightning/uiRecordApi';

import BADGE_NAME_FIELD from '@salesforce/schema/Recommended_Badge__c.Badge_Name__c';
import HIGH_PRIORITY_ID_FIELD from '@salesforce/schema/Recommended_Badge__c.High_Priority_Id__c';
import ID_FIELD from '@salesforce/schema/Recommended_Badge__c.Id';
import TIME_ESTIMATE_FIELD from '@salesforce/schema/Recommended_Badge__c.Time_Estimate__c';
import TYPE_FIELD from '@salesforce/schema/Recommended_Badge__c.Type__c';
import URL_FIELD from '@salesforce/schema/Recommended_Badge__c.URL__c';

import getMixCategoryData from '@salesforce/apex/PrivateViewController.getMixCategoryData';
import getPrivateMixRecommendedBadges from '@salesforce/apex/PrivateViewController.getPrivateMixRecommendedBadges';

const CHANGE_MIX_CATEGORY = 'Change Mix Category';
const DELETE_RECOMMENDED_BADGE = 'Delete Recommended Badge';
const DROPDOWN_VIEW_LABEL = 'Select View';

const ACTIONS = [
    {
        label: DELETE_RECOMMENDED_BADGE,
        name: DELETE_RECOMMENDED_BADGE
    },
    {
        label: CHANGE_MIX_CATEGORY,
        name: CHANGE_MIX_CATEGORY
    }
]

const HIGH_PRIORITY_OPTION = {
    label: 'High Priority',
    value: 'High Priority'
};

const HIGH_PRIORITY_PREFIX = 'HP';

const LOOKUP_OBJECT_NAME = 'Mix Category';
const PROMPT_HEADER = 'Change Mix Category';
const RESULT_ICON_NAME = 'custom:custom46';
const SPINNER_TEXT = 'Retrieving badges';

const TABLE_COLUMNS = [
    {
        label: 'Badge',
        fieldName: URL_FIELD.fieldApiName,
        type: 'url',
        typeAttributes: {
            label: {
                fieldName: BADGE_NAME_FIELD.fieldApiName
            }
        }
    },
    {
        label: 'Type',
        fieldName: TYPE_FIELD.fieldApiName
    },
    {
        label: 'Time Estimate',
        fieldName: TIME_ESTIMATE_FIELD.fieldApiName
    },
    {
        type: 'action',
        typeAttributes: {
            rowActions: ACTIONS
        }
    }
]

export default class PrivateViewContainer extends LightningElement {
    @api divClasses;
    displayPrompt;
    dropdownViewLabel = DROPDOWN_VIEW_LABEL;
    dropdownViewValue = 'High Priority';
    isLoading = true;
    keyField = HIGH_PRIORITY_ID_FIELD.fieldApiName;
    lookupItems;
    lookupObjectName = LOOKUP_OBJECT_NAME;
    lookupResultIconName = RESULT_ICON_NAME;
    mixCategoryData;
    promptHeader = PROMPT_HEADER;
    promptIsLoading;
    @track recommendedBadgeData;
    selectedRecommendedBadge;
    spinnerText = SPINNER_TEXT;
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

            this.recommendedBadgeData = await getPrivateMixRecommendedBadges();
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
            this.keyField = HIGH_PRIORITY_ID_FIELD.fieldApiName;
        } else {
            this.keyField = ID_FIELD.fieldApiName;
        }

        this.dropdownViewValue = event.detail;
        this.tableData = this.recommendedBadgeData[event.detail];
    }

    handleRowAction(event) {
        switch(event.detail.action.name) {
            case DELETE_RECOMMENDED_BADGE:
                this.handleDelete(event.detail.row);
                break;
            case CHANGE_MIX_CATEGORY:
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
            await deleteRecord(recommendedBadgeId);
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
            const fields = recommendedBadge;
            const recommendedBadgeToUpdate = { fields };
            await updateRecord(recommendedBadgeToUpdate);
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
        this.recommendedBadgeData = await getPrivateMixRecommendedBadges();
        this.tableData = this.recommendedBadgeData[this.dropdownViewValue];
    }
}