import { LightningElement, api, track } from 'lwc';

import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { deleteRecord, updateRecord } from 'lightning/uiRecordApi';

import BADGE_NAME_FIELD from '@salesforce/schema/Recommended_Badge__c.BadgeName__c';
import HIGH_PRIORITY_FIELD from '@salesforce/schema/Recommended_Badge__c.High_Priority__c';
import HIGH_PRIORITY_ID_FIELD from '@salesforce/schema/Recommended_Badge__c.High_Priority_Id__c';
import BADGE_ID_FIELD from '@salesforce/schema/Recommended_Badge__c.Id';
import TIME_ESTIMATE_FIELD from '@salesforce/schema/Recommended_Badge__c.Time_Estimate__c';
import TYPE_FIELD from '@salesforce/schema/Recommended_Badge__c.Type__c';
import URL_FIELD from '@salesforce/schema/Recommended_Badge__c.URL__c';
import MIX_CATEGORY_NAME_FIELD from '@salesforce/schema/Mix_Category__c.Name';
import MIX_CATEGORY_ID_FIELD from '@salesforce/schema/Mix_Category__c.Id';
import RECOMMENDED_BADGE_MIX_FIELD from '@salesforce/schema/Mix_Category__c.Recommended_Badge_Mix__c';
import RECOMMENDED_BADGE_MIX_NAME_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.Name';
import PRIVATE_MIX_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.Private_Mix__c';

import getMixCategoryData from '@salesforce/apex/PrivateViewController.getMixCategoryData';
import getPrivateMixRecommendedBadges from '@salesforce/apex/PrivateViewController.getPrivateMixRecommendedBadges';

const CHANGE_MIX_CATEGORY = 'Change Mix Category';
const DELETE_RECOMMENDED_BADGE = 'Delete Recommended Badge';
const DROPDOWN_VIEW_LABEL = 'Select View';
const TOGGLE_HIGH_PRIORITY = 'Toggle High Priority';

const ACTIONS = [
    {
        label: DELETE_RECOMMENDED_BADGE,
        name: DELETE_RECOMMENDED_BADGE
    },
    {
        label: CHANGE_MIX_CATEGORY,
        name: CHANGE_MIX_CATEGORY
    },
    {
        label: TOGGLE_HIGH_PRIORITY,
        name: TOGGLE_HIGH_PRIORITY
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
    displayPrompt = false;
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
                if(mixCategory.Recommended_Badge_Mix__r[PRIVATE_MIX_FIELD.fieldApiName]) {
                    this.viewOptions.push({
                        label: mixCategory[MIX_CATEGORY_NAME_FIELD.fieldApiName],
                        value: mixCategory[MIX_CATEGORY_NAME_FIELD.fieldApiName]
                    });
                }
            }

            this.recommendedBadgeData = await getPrivateMixRecommendedBadges();
            if(this.recommendedBadgeData) {
                this.tableData = this.recommendedBadgeData[this.dropdownViewValue];
            }
            this.isLoading = false;
        } catch(err) {
            console.error(err);
        }
    }

    populateLookupItems() {
        this.lookupItems = [];
        for(let mixCategory of this.mixCategoryData) {
            this.lookupItems.push({
                Id: mixCategory[MIX_CATEGORY_ID_FIELD.fieldApiName],
                Name: mixCategory[MIX_CATEGORY_NAME_FIELD.fieldApiName],
                SecondaryFieldValue: mixCategory.Recommended_Badge_Mix__r[RECOMMENDED_BADGE_MIX_NAME_FIELD.fieldApiName],
                ParentId: mixCategory[RECOMMENDED_BADGE_MIX_FIELD.fieldApiName]
            });
        }
    }

    handleDropdownChange(event) {
        if(event.detail === 'High Priority') {
            this.keyField = HIGH_PRIORITY_ID_FIELD.fieldApiName;
        } else {
            this.keyField = BADGE_ID_FIELD.fieldApiName;
        }

        this.dropdownViewValue = event.detail;
        this.tableData = this.recommendedBadgeData[event.detail];
    }

    handleRowAction(event) {
        switch(event.detail.action.name) {
            case CHANGE_MIX_CATEGORY:
                this.selectedRecommendedBadge = event.detail.row;
                this.populateLookupItems();
                this.displayPrompt = true;
                break;
            case DELETE_RECOMMENDED_BADGE:
                this.handleDelete(event.detail.row);
                break;
            case TOGGLE_HIGH_PRIORITY:
                this.toggleHighPriority(event.detail.row);
                break;
        }
    }

    async toggleHighPriority(rowToToggle) {
        this.isLoading = true;
        let recommendedBadgeId;
        let newHighPriorityValue;

        if(this.dropdownViewValue === 'High Priority') {
            recommendedBadgeId = rowToToggle.Id.replace(HIGH_PRIORITY_PREFIX, '');
            newHighPriorityValue = false;
        } else {
            recommendedBadgeId = rowToToggle.Id;
            newHighPriorityValue = true;
        }

        let fields = {};
        fields[BADGE_ID_FIELD.fieldApiName] = recommendedBadgeId;
        fields[HIGH_PRIORITY_FIELD.fieldApiName] = newHighPriorityValue;
        let recordInput = { fields };

        try {
            await updateRecord(recordInput);
            this.refreshRecommendedBadgeData();

            const showToastEvent = new ShowToastEvent({
                title: 'Success',
                message: `Toggled high priority for ${rowToToggle[BADGE_NAME_FIELD.fieldApiName]} recommended badge.`,
                variant: 'success'
            });
            this.dispatchEvent(showToastEvent);
        } catch(err) {
            console.error(err);
        }

        this.isLoading = false;
    }

    async handleDelete(rowToDelete) {
        this.isLoading = true;
        let recommendedBadgeId;

        if(this.dropdownViewValue === 'High Priority') {
            recommendedBadgeId = rowToDelete.Id.replace(HIGH_PRIORITY_PREFIX, '');
        } else {
            recommendedBadgeId = rowToDelete.Id;
        }

        try {
            await deleteRecord(recommendedBadgeId);
            this.refreshRecommendedBadgeData();

            const showToastEvent = new ShowToastEvent({
                title: 'Success',
                message: `Deleted ${rowToDelete[BADGE_NAME_FIELD.fieldApiName]} recommended badge.`,
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
            Id: this.selectedRecommendedBadge[BADGE_ID_FIELD.fieldApiName],
            Mix_Category__c: selectedMixCategory[MIX_CATEGORY_ID_FIELD.fieldApiName]
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
                message: `Changed Mix Category for ${this.selectedRecommendedBadge[BADGE_NAME_FIELD.fieldApiName]} to ${selectedMixCategory[MIX_CATEGORY_NAME_FIELD.fieldApiName]}`,
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