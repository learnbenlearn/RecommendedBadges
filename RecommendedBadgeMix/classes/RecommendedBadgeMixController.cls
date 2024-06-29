/**
 * @description       : Apex controller for recommendedBadgeMixContainer LWC.
 * @author            : Ben Learn
 * @last modified on  : 02-07-2023
 * @last modified by  : Ben Learn
**/
public without sharing class RecommendedBadgeMixController {
    /**
    * @description 
    * @author Ben Learn | 03-11-2022 
    * @return RecommendedBadgeMixWrapper 
    **/
    /**
     * Method to retrieve necessary data - including mix categories, recommended badges, and recommended trails for public recommended
     *  badge mixes, as well as the name of the default mix - for recommendedBadgeMixContainer.
     * @return  `DataWrapper`
     */
    @AuraEnabled(cacheable=true scope='global')
    public static DataWrapper getData() {
        List<Mix_Category__c> mixCategories = new MixCategoriesSelector().selectRecommendedBadgesAndTrails();
        Map<String, List<Mix_Category__c>> categoriesByMix = new Map<String, List<Mix_Category__c>>();

        for(Mix_Category__c mixCategory : mixCategories) {
            if(categoriesByMix.get(mixCategory.Recommended_Badge_Mix__r.Name) == null) {
                categoriesByMix.put(mixCategory.Recommended_Badge_Mix__r.Name, new List<Mix_Category__c>{mixCategory});
            } else {
                List<Mix_Category__c> existingMixCategories = categoriesByMix.get(mixCategory.Recommended_Badge_Mix__r.Name);
                existingMixCategories.add(mixCategory);
                categoriesByMix.put(mixCategory.Recommended_Badge_Mix__r.Name, existingMixCategories);
            }
        }

        List<Recommended_Badge_Mix__c> defaultMix = new RecommendedBadgeMixesSelector().selectDefaultMix();
        String defaultMixName;
        if(defaultMix.size() > 0) {
            defaultMixName = defaultMix[0].Name;
        } else {
            defaultMixName = mixCategories[0].Recommended_Badge_Mix__r.Name;
        }
        
        DataWrapper data = new DataWrapper(categoriesByMix, defaultMixName);

        return data;
    }

    @TestVisible
    private class DataWrapper {
        /**
         * Mix Categories (including children Recommended Badges/Trails) by parent Recommended Badge Mix
         */
        @AuraEnabled
        public Map<String, List<Mix_Category__c>> categoriesByMix {get;set;}

        /**
         * Name of default Recommended Badge Mix
         */        
        @AuraEnabled 
        public String defaultMix {get;set;}
    
        private DataWrapper(Map<String, List<Mix_Category__c>> categoriesByMix, String defaultMix) {
            this.categoriesByMix = categoriesByMix;
            this.defaultMix = defaultMix;
        }
    }
}