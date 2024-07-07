/* eslint-disable sort-imports, one-var, @lwc/lwc/no-for-of, no-underscore-dangle */
import { LightningElement, wire } from 'lwc';

import { CurrentPageReference } from 'lightning/navigation';

import getData from '@salesforce/apex/RecommendedBadgeMixController.getData';
import getSortOptions from '@salesforce/apex/SortCustomMetadataController.getSortOptions';

import { sortAlphabetic, sortCustom } from 'c/sortUtility';

import BADGE_ID_FIELD from '@salesforce/schema/Recommended_Badge__c.Id';
import BADGE_LEVEL_FIELD from '@salesforce/schema/Recommended_Badge__c.Level__c';
import BADGE_HYPERLINKEDNAME_FIELD from '@salesforce/schema/Recommended_Badge__c.HyperlinkedName__c';
import BADGE_NAME_FIELD from '@salesforce/schema/Recommended_Badge__c.BadgeName__c';
import RECOMMENDED_BADGE_NAME_FIELD from '@salesforce/schema/Recommended_Badge__c.Name';
import BADGE_TYPE_FIELD from '@salesforce/schema/Recommended_Badge__c.Type__c';
import BADGE_URL_FIELD from '@salesforce/schema/Recommended_Badge__c.URL__c';
import TRAIL_ID_FIELD from '@salesforce/schema/Recommended_Trail__c.Id';
import TRAIL_LEVEL_FIELD from '@salesforce/schema/Recommended_Trail__c.Level__c';
import TRAIL_HYPERLINKEDNAME_FIELD from '@salesforce/schema/Recommended_Trail__c.HyperlinkedName__c';
import TRAIL_NAME_FIELD from '@salesforce/schema/Recommended_Trail__c.TrailName__c';
import RECOMMENDED_TRAIL_NAME_FIELD from '@salesforce/schema/Recommended_Trail__c.Name';
import TRAIL_URL_FIELD from '@salesforce/schema/Recommended_Trail__c.URL__c';
import MIX_CATEGORY_ID_FIELD from '@salesforce/schema/Mix_Category__c.Id';
import MIX_CATEGORY_NAME_FIELD from '@salesforce/schema/Mix_Category__c.Name';
import MIX_CATEGORY_RECOMMENDED_BADGE_MIX_FIELD from '@salesforce/schema/Mix_Category__c.Recommended_Badge_Mix__c';
import RECOMMENDED_BADGE_MIX_NAME_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.Name';
import RECOMMENDED_BADGE_MIX_LAST_UPDATED_DATE_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.Last_Updated_Date__c';
//import RECOMMENDED_BADGE_MIX_FIELD from '@salesforce/schema/Mix_Category__c.Recommended_Badge_Mix__r';


const SPINNER_TEXT = 'Retrieving recommended badges';

/* eslint-disable sort-keys */
const TREEGRID_COLUMNS = [
    {
        type: 'url',
        fieldName: BADGE_URL_FIELD.fieldApiName,
        label: 'Name',
        typeAttributes: {
            label: {
                fieldName: RECOMMENDED_BADGE_NAME_FIELD.fieldApiName
            }
        },
        initialWidth: 500
    },
    {
        fieldName: BADGE_TYPE_FIELD.fieldApiName,
        label: 'Type'
    },
    {
        fieldName: BADGE_LEVEL_FIELD.fieldApiName,
        label: 'Level'
    },
]

/*
{
    "type": "comm__namedPage",
    "attributes": {
        "name": "Home"
    },
    "state": {
        "app": "commeditor",
        "redirect": "false"
    }
}
{
    "type": "comm__namedPage",
    "attributes": {
        "name": "Home"
    },
    "state": {
        "app": "commeditor"
    }
}

{
    "type": "standard__namedPage",
    "attributes": {
        "pageName": "home"
    },
    "state": {}
}
*/

export default class RecommendedBadgeMixContainer extends LightningElement {
    categoriesByMix;
    displayTable;
    isLoading = true;
    currentLastUpdatedDate;
    lastUpdatedDatesByRecommendedBadgeMix;
    mixLabel = 'Select Badge Mix';
    mixOptions;
    mixValue;
    keyField = BADGE_ID_FIELD.fieldApiName;
    sortLabel = 'Sort By';
    sortOptions;
    sortValue;
    spinnerText = SPINNER_TEXT;
    treegridColumns = TREEGRID_COLUMNS;
    treegridData;
    treegridDataByMix;

    renderedCallback() {
        if(this.treegridData && !this.displayTable) {
            this.displayTable = true;
        }

        if(this.isLoading && this.treegridData) {
            this.isLoading = false;
        }
    }

    @wire(CurrentPageReference)
    pageRef;

    @wire(getData)
    parseData({error, data}) {
        if(data) {
            this.categoriesByMix = data.categoriesByMix;
            this.populateMixDropdown(data.defaultMix);

            this.parseTreegridData();

            this.currentLastUpdatedDate = this.lastUpdatedDatesByRecommendedBadgeMix[data.defaultMix];
            this.treegridData = this.treegridDataByMix[data.defaultMix];

            this.displayTable = true;
            this.isLoading = false;
        } else if(error) {
            this.template.querySelector('c-error').handleError(error);
        }
    }

    @wire(getSortOptions, {componentName: 'recommendedBadgeMixContainer'})
    parseSortOptions({error, data}) {
        if(data) {
            this.sortOptions = [];
            for(const option of data) {
                /* eslint-disable sort-keys */
                this.sortOptions.push({
                    label: option.MasterLabel,
                    value: option.Field_API_Name__c,
                    sortableFieldValues: option.Sortable_Field_Values__r
                })   
            }
        } else if(error) {
            this.template.querySelector('c-error').handleError(error);
        }
    }

    populateMixDropdown(defaultMix) {
        const options = [];
        /* eslint-disable id-length */
        for(const a of Object.keys(this.categoriesByMix)) {
            options.push({label: a, value: a});
        }
        this.mixOptions = options;
        this.mixValue = defaultMix;
    }

    parseTreegridData() {
        this.lastUpdatedDatesByRecommendedBadgeMix = {};
        this.treegridDataByMix = {};

        for(const mix in this.categoriesByMix) {
            const extensibleMix = this.categoriesByMix[mix].map(item => {
                const newCategoryChildren = [];
                if(item.Recommended_Badges__r) {
                    for(const badge of item.Recommended_Badges__r) {
                        /* eslint-disable sort-keys, camelcase */
                        newCategoryChildren.push({
                            Id: badge[BADGE_ID_FIELD.fieldApiName],
                            Name: badge[BADGE_NAME_FIELD.fieldApiName],
                            Level__c: badge[BADGE_LEVEL_FIELD.fieldApiName],
                            Type__c: badge[BADGE_TYPE_FIELD.fieldApiName],
                            URL__c: badge[BADGE_URL_FIELD.fieldApiName],
                        });
                    }
                }

                if(item.Recommended_Trails__r) {
                    for(const trail of item.Recommended_Trails__r) {
                        newCategoryChildren.push({
                            Id: trail[TRAIL_ID_FIELD.fieldApiName],
                            Name: trail[TRAIL_NAME_FIELD.fieldApiName],
                            Level__c: trail[TRAIL_LEVEL_FIELD.fieldApiName],
                            Type__c: 'Trail',
                            URL__c: trail[TRAIL_URL_FIELD.fieldApiName],
                            HyperlinkedName__c: trail[TRAIL_HYPERLINKEDNAME_FIELD.fieldApiName]
                        })
                    }
                }
                
                const newCategory = {
                    Id: item[MIX_CATEGORY_ID_FIELD.fieldApiName],
                    Name: item[MIX_CATEGORY_NAME_FIELD.fieldApiName],
                    URL__c: `/${item[MIX_CATEGORY_ID_FIELD.fieldApiName]}`, // this.pageRef.type === "comm__namedPage" ? undefined : '/' + item.Id,
                    _children: newCategoryChildren,
                    Recommended_Badge_Mix__c: item[MIX_CATEGORY_RECOMMENDED_BADGE_MIX_FIELD.fieldApiName],
                };

                if(!(item.Recommended_Badge_Mix__r[RECOMMENDED_BADGE_MIX_NAME_FIELD.fieldApiName] in this.lastUpdatedDatesByRecommendedBadgeMix)) {
                    this.lastUpdatedDatesByRecommendedBadgeMix[item.Recommended_Badge_Mix__r[RECOMMENDED_BADGE_MIX_NAME_FIELD.fieldApiName]] = item.Recommended_Badge_Mix__r[RECOMMENDED_BADGE_MIX_LAST_UPDATED_DATE_FIELD.fieldApiName];
                }

                return newCategory;
            });
            this.treegridDataByMix[mix] = extensibleMix;
        }
    }

    handleMixChange(event) {
        this.currentLastUpdatedDate = this.lastUpdatedDatesByRecommendedBadgeMix[event.detail];
        this.treegridData = this.treegridDataByMix[event.detail];
    }

    handleSortChange(event) {
        this.displayTable = false;
        let sortableFieldValues;
        let tempTreegridData = [];
        tempTreegridData = this.treegridData;

        for(const sortOption of this.sortOptions) {
            if((sortOption.value === event.detail) && sortOption.sortableFieldValues) {
                sortableFieldValues = [];

                for(const sortableFieldValue of sortOption.sortableFieldValues) {
                    sortableFieldValues.splice(sortableFieldValue.Sort_Order__c - 1, 0, sortableFieldValue.MasterLabel);
                }
                break;
            }
        }

        for(const category of tempTreegridData) {
            /* eslint-disable no-magic-numbers */
            if(category._children.length > 1) {
                if(sortableFieldValues) {
                    category._children = sortCustom(event.detail, category._children, sortableFieldValues);
                } else {
                    category._children = sortAlphabetic(event.detail, category._children);
                }
            }
        }

        this.treegridData = tempTreegridData;
    }

    handleExpandAll() {
        this.isLoading = true;
        this.template.querySelector('c-treegrid').expandAll();
    }

    handleCollapseAll() {
        this.isLoading = true;
        this.template.querySelector('c-treegrid').collapseAll();
    }
}