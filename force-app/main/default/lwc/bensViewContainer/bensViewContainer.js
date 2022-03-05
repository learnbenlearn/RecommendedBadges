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
]

export default class BensViewContainer extends LightningElement {
    dropdownViewLabel = 'Select View';
    dropdownViewValue = '';
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

            let recommendedBadgeData = await getBensMixRecommendedBadges();

            console.log(JSON.parse(JSON.stringify(recommendedBadgeData)));

        } catch(err) {
            console.error(err);
        }
    }

    handleDropdownChange(event) {
        console.log(event.detail);
    }
}