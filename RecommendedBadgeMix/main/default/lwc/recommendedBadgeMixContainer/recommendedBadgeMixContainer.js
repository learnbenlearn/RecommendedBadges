import { LightningElement, wire } from 'lwc';

import getData from '@salesforce/apex/RecommendedBadgeMixController.getData';

import getSortOptions from '@salesforce/apex/SortCustomMetadataController.getSortOptions';

import { sortAlphabetic, sortCustom } from 'c/sortUtility';

import ID_FIELD from '@salesforce/schema/Recommended_Badge__c.Id';
import LEVEL_FIELD from '@salesforce/schema/Recommended_Badge__c.Type__c';
import NAME_FIELD from '@salesforce/schema/Recommended_Badge__c.Name';
import TYPE_FIELD from '@salesforce/schema/Recommended_Badge__c.Type__c';
import URL_FIELD from '@salesforce/schema/Recommended_Badge__c.URL__c';

const SPINNER_TEXT = 'Retrieving recommended badges';

const TREEGRID_COLUMNS = [
    {
        type: 'url',
        fieldName: URL_FIELD.fieldApiName,
        label: 'Name',
        typeAttributes: {
            label: {
                fieldName: NAME_FIELD.fieldApiName
            }
        },
        initialWidth: 500
    },
    {
        fieldName: TYPE_FIELD.fieldApiName,
        label: 'Type'
    },
    {
        fieldName: LEVEL_FIELD.fieldApiName,
        label: 'Level'
    }
]

export default class RecommendedBadgeMixContainer extends LightningElement {
    categoriesByMix;
    displayTable;
    isLoading = true;
    currentLastUpdatedDate;
    lastUpdatedDatesByRecommendedBadgeMix;
    mixLabel = 'Select Badge Mix';
    mixOptions;
    mixValue;
    keyField = ID_FIELD.fieldApiName;
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

    @wire(getData)
    parseData({error, data}) {
        if(data) {
            this.categoriesByMix = data.categoriesByMix;
            this.populateMixDropdown(data.defaultMix);

            this.parseTreegridData();

            this.currentLastUpdatedDate = this.lastUpdatedDatesByRecommendedBadgeMix[data.defaultMix];
            this.treegridData = this.treegridDataByMix[data.defaultMix];
            console.log(this.currentLastUpdatedDate);

            this.displayTable = true;
            this.isLoading = false;
        } else if(error) {
            console.error(error);
        }
    }

    @wire(getSortOptions, {componentName: 'recommendedBadgeMixContainer'})
    parseSortOptions({error, data}) {
        if(data) {
            this.sortOptions = [];
            for(let option of data) {
                this.sortOptions.push({
                    label: option.MasterLabel,
                    value: option.Field_API_Name__c,
                    sortableFieldValues: option.Sortable_Field_Values__r
                })   
            }
        } else if(error) {
            console.error(error);
        }
    }

    populateMixDropdown(defaultMix) {
        let options = [];
        for(let a of Object.keys(this.categoriesByMix)) {
            options.push({label: a, value: a});
        }
        this.mixOptions = options;
        this.mixValue = defaultMix;
    }

    parseTreegridData() {
        this.lastUpdatedDatesByRecommendedBadgeMix = {};
        this.treegridDataByMix = {};

        for(let mix in this.categoriesByMix) {
            let extensibleMix = this.categoriesByMix[mix].map(item => {
                let newCategoryChildren = [];

                /*if(item.Recommended_Badges__r) {
                    for(let badge of item.Recommended_Badges__r) {
                        newCategoryChildren.push({
                            Id: badge.Id,
                            Name: badge.Badge_Name__c,
                            Level__c: badge.Level__c,
                            Type__c: badge.Type__c,
                            URL__c: badge.URL__c,
                        });
                    }
                }

                if(item.Recommended_Trails__r) {
                    for(let trail of item.Recommended_Trails__r) {
                        newCategoryChildren.push({
                            Id: trail.Id,
                            Name: trail.Trail_Name__c,
                            Level__c: trail.Level__c,
                            Type__c: 'Trail',
                            URL__c: trail.URL__c
                        })
                    }
                }
*/
                let newCategory = {
                    Id: item.Id,
                    Name: item.Name,
                    URL__c: '/' + item.Id,
                    _children: newCategoryChildren,
                    Recommended_Badge_Mix__c: item.Recommended_Badge_Mix__c,
                    RecommendedBadgeMixLastUpdatedDate: item.Recommended_Badge_Mix__r.Last_Updated_Date__c
                };

                if(!(item.Recommended_Badge_Mix__r.Name in this.lastUpdatedDatesByRecommendedBadgeMix)) {
                    this.lastUpdatedDatesByRecommendedBadgeMix[item.Recommended_Badge_Mix__r.Name] = item.Recommended_Badge_Mix__r.Last_Updated_Date__c;
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

        for(let sortOption of this.sortOptions) {
            if((sortOption.value === event.detail) && sortOption.sortableFieldValues) {
                sortableFieldValues = [];

                for(let sortableFieldValue of sortOption.sortableFieldValues) {
                    sortableFieldValues.splice(sortableFieldValue.Sort_Order__c - 1, 0, sortableFieldValue.MasterLabel);
                }
                break;
            }
        }

        for(let category of tempTreegridData) {
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