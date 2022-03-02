import { LightningElement, wire } from 'lwc';

import getSetupData from '@salesforce/apex/RecommendedBadgeMixService.getSetupData';

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
    dropdownLabel = 'Select Badge Mix';
    dropdownOptions;
    dropdownValue;
    keyField = 'Name';
    treegridColumns = TREEGRID_COLUMNS;
    treegridData;
    treegridDataByMix;

    @wire(getSetupData)
    parseSetupData({error, data}) {
        if(data) {
            this.categoriesByMix = data.categoriesByMix;
            this.populateDropdown(data.defaultMix);

            this.parseTreegridData();

            this.treegridData = this.treegridDataByMix[data.defaultMix];

            this.displayTable = true;
            console.log(this.treegridData);
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

    handleDropdownChange(event) {
        this.treegridData = this.treegridDataByMix[event.detail];
    }

    handleExpandAll() {
        this.template.querySelector('c-treegrid').expandAll();
    }

    handleCollapseAll() {
        this.template.querySelector('c-treegrid').collapseAll();
    }
}