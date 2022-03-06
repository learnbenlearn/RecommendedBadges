import { LightningElement } from 'lwc';

import getBensMixCategoryNames from '@salesforce/apex/BensViewService.getBensMixCategoryNames';
import getBensMixRecommendedBadges from '@salesforce/apex/BensViewService.getBensMixRecommendedBadges';

const HARDCODED_VIEW_OPTIONS = [
    {
        label: 'High Priority',
        value: 'High Priority'
    },
    {
        label: 'Add to Recommended Badges Mix',
        value: 'Add to Recommended Badges Mix'
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

/*
{
  "High Priority": [
    {
      "Add_to_Recommended_Badges_Mix__c": false,
      "Badge_Icon__c": "<img src=\"https://res.cloudinary.com/hy4kyit2a/f_auto,fl_lossy,q_70/learn/modules/mrkt_cloud_basics/bb76c1487a83ad8836d26c10f03ddfa4_badge.png\" alt=\"Marketing Cloud Basics\" style=\"height:50px; width:50px;\" border=\"0\"/>",
      "High_Priority__c": true,
      "Level__c": "Beginner",
      "Time_Estimate_Minutes__c": 30,
      "Time_Estimate__c": "0 hr 30 min",
      "Type__c": "Module",
      "Mix_Category__r": {
        "Name": "Marketing Cloud",
        "Recommended_Badge_Mix__c": "a0A0x000002h1PUEAY",
        "Id": "a090x00001CTIWrAAP"
      }
    },
    */