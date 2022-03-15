import { LightningElement, wire, track } from 'lwc';

import getSetupData from '@salesforce/apex/RecommendedBadgeMixService.getSetupData';

import getSortOptions from '@salesforce/apex/SortCustomMetadataService.getSortOptions';

import { sortAlphabetic, sortCustom } from 'c/sortUtility';

const TREEGRID_COLUMNS = [
    {
        type: 'url',
        fieldName: 'URL__c',
        label: 'Name',
        typeAttributes: {
            label: {
                fieldName: 'Name'
            }
        },
        initialWidth: 500
    },
    {
        fieldName: 'Type__c',
        label: 'Type'
    },
    {
        fieldName: 'Level__c',
        label: 'Level'
    }
]

export default class RecommendedBadgeMixContainer extends LightningElement {
    categoriesByMix;
    displayTable;
    isLoading = true;
    mixLabel = 'Select Badge Mix';
    mixOptions;
    mixValue;
    keyField = 'Name';
    sortLabel = 'Sort By';
    sortOptions;
    sortValue;
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

    @wire(getSetupData)
    parseSetupData({error, data}) {
        if(data) {
            this.categoriesByMix = data.categoriesByMix;
            this.populateDropdown(data.defaultMix);

            this.parseTreegridData();

            this.treegridData = this.treegridDataByMix[data.defaultMix];

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

    populateDropdown(defaultMix) {
        let options = [];
        for(let a of Object.keys(this.categoriesByMix)) {
            options.push({label: a, value: a});
        }
        this.dropdownOptions = options;
        this.dropdownValue = defaultMix;
    }

    parseTreegridData() {
        this.treegridDataByMix = {};
        for(let mix in this.categoriesByMix) {
            let extensibleMix = this.categoriesByMix[mix].map(item => {
                let newCategoryChildren = [];

                if(item.Recommended_Badges__r) {
                    for(let badge of item.Recommended_Badges__r) {
                        newCategoryChildren.push({
                            Name: badge.Badge_Name__c,
                            Level__c: badge.Level__c,
                            Type__c: badge.Type__c,
                            URL__c: badge.URL__c
                        });
                    }

                }

                if(item.Recommended_Trails__r) {
                    for(let trail of item.Recommended_Trails__r) {
                        newCategoryChildren.push({
                            Name: trail.Trail_Name__c,
                            Level__c: trail.Level__c,
                            Type__c: 'Trail',
                            URL__c: trail.URL__c
                        })
                    }
                }

                let newCategory = {
                    Name: item.Name,
                    URL__c: '/' + item.Id,
                    _children: newCategoryChildren
                };

                return newCategory;
            });

            this.treegridDataByMix[mix] = extensibleMix;
        }
    }

    handleMixChange(event) {
        this.treegridData = this.treegridDataByMix[event.detail];
    }

    handleSortChange(event) {
        this.displayTable = false;
        let sortableFieldValues;
        let tempTreegridData = [];
        tempTreegridData = this.treegridData;

        for(let sortOption of this.sortOptions) {
            if((sortOption.value === event.detail) && this.sortOptions.sortableFieldValues) {
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