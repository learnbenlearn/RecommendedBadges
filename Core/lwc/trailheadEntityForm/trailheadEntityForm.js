/**
 * Form component to override the New and Edit standard actions on Recommended Badge and Recommended Trail. Retrieves available Badges/Trails from 
 * Trail Tracker Provider through an Apex call. 
 * @author Ben Learn
 * @since 06-08-2024
 * @group Core
 */
import { LightningElement, api, wire } from 'lwc';

import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import BADGE_API_NAME_FIELD from '@salesforce/schema/Recommended_Badge__c.BadgeAPIName__c';
import BADGE_NAME_FIELD from '@salesforce/schema/Recommended_Badge__c.Badge_Name__c';
import CATEGORY_RANK_FIELD from '@salesforce/schema/Recommended_Badge__c.Category_Rank__c';
import HIGH_PRIORITY_FIELD from '@salesforce/schema/Recommended_Badge__c.High_Priority__c';
import HOURS_ESTIMATE_FIELD from '@salesforce/schema/Recommended_Badge__c.Hours_Estimate__c';
import MINUTES_ESTIMATE_FIELD from '@salesforce/schema/Recommended_Badge__c.Minutes_Estimate__c';
import BADGE_MIX_CATEGORY_FIELD from '@salesforce/schema/Recommended_Badge__c.Mix_Category__c';
import TRAIL_API_NAME_FIELD from '@salesforce/schema/Recommended_Trail__c.TrailAPIName__c';
import TRAIL_NAME_FIELD from '@salesforce/schema/Recommended_Trail__c.Trail_Name__c';
import TRAIL_MIX_CATEGORY_FIELD from '@salesforce/schema/Recommended_Trail__c.Mix_Category__c';

import getTraillheadEntitiesByApiName from '@salesforce/apex/TrailheadEntityFormController.getTrailheadEntitiesByAPIName';

export default class TrailheadEntityForm extends NavigationMixin(LightningElement) {
    cardTitle;
    objectApiName;
    @api recordId;
    badgeFields = [BADGE_MIX_CATEGORY_FIELD, HOURS_ESTIMATE_FIELD, MINUTES_ESTIMATE_FIELD, CATEGORY_RANK_FIELD, HIGH_PRIORITY_FIELD];
    saveAndNew = false;
    selectedName;
    selectedApiName;
    trailFields = [TRAIL_MIX_CATEGORY_FIELD];
    fields;

    lookupObjectName;
    lookupPlaceholder;
    lookupResultIconName;
    lookupItems = [];
    selectedLookupId;

    get sObjectName() {
        return this.objectApiName;
    }
    @api
    set sObjectName(value) {
        this.objectApiName = value;
        switch(value) {
            case 'Recommended_Badge__c':
                this.cardTitle = 'New Recommended Badge';
                this.fields = [BADGE_MIX_CATEGORY_FIELD, HOURS_ESTIMATE_FIELD, MINUTES_ESTIMATE_FIELD, CATEGORY_RANK_FIELD, HIGH_PRIORITY_FIELD];
                this.lookupObjectName = 'Badge';
                this.lookupPlaceholder = 'Search Badges...';
                this.lookupResultIconName = 'custom:custom48';
                break;
            case 'Recommended_Trail__c':
                this.cardTitle = 'New Recommended Trail';
                this.fields = [TRAIL_MIX_CATEGORY_FIELD];
                this.lookupObjectName = 'Trail';
                this.lookupPlaceholder = 'Search Trails...';
                this.lookupResultIconName = 'custom:custom64';
                break;
        }
    }

    @wire(getTraillheadEntitiesByApiName, { childEntityType: '$objectApiName'})
    parseBadgesByApiName({error, data}) {
        if(data) {
            this.lookupItems = [];
            for(let record of data.records) {
                this.lookupItems.push({
                    Id: record.trailheadapp__API_Name__c,
                    Name: record.Name,
                    SecondaryFieldValue: record.trailheadapp__API_Name__c
                });
            }
        } else if(error) {
            this.template.querySelector('c-error').handleError(err);
        }
    }

    handleLookupSelect(event) {
        this.selectedName = event.detail.Name;
        this.selectedApiName = event.detail.Id;
    }
    
    handleCancel() {
        window.history.back();
    }

    handleLoad(event) {
        let record = event.detail.record ?? Object.values(event.detail.records)[0];
        switch(this.objectApiName) {
            case 'Recommended_Badge__c':
                this.selectedLookupId = record.fields[BADGE_API_NAME_FIELD.fieldApiName].value;
                break;
            case 'Recommended_Trail__c':
                this.selectedLookupId = record.fields[TRAIL_API_NAME_FIELD.fieldApiName].value;
                break;
        }
    }

    handleSave() {
        this.saveAndNew = false;
    }

    handleSaveAndNew() {
        this.saveAndNew = true;
    }

    handleSuccess(event) {
        if(this.saveAndNew) {
            let inputFields = this.template.querySelectorAll('lightning-input-field');
            inputFields.forEach(inputField => inputField.reset());
            this.template.querySelector('c-lookup').reset();
            this.dispatchEvent(new ShowToastEvent({
                title: 'Success',
                message: `${event.detail.fields.Name.value} was saved.`,
                variant: 'success'
            }))
        } else {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    actionName: 'view',
                    recordId: event.detail.id
                }
            });
        }
    }

    handleSubmit(event) {
        event.preventDefault();
        const fields = event.detail.fields;
        switch(this.objectApiName) {
            case 'Recommended_Badge__c':
                fields[BADGE_API_NAME_FIELD.fieldApiName] = this.selectedApiName;
                fields[BADGE_NAME_FIELD.fieldApiName] = this.selectedName;
                break;
            case 'Recommended_Trail__c':                
            fields[TRAIL_API_NAME_FIELD.fieldApiName] = this.selectedApiName;
            fields[TRAIL_NAME_FIELD.fieldApiName] = this.selectedName;
                break;
        }
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
}