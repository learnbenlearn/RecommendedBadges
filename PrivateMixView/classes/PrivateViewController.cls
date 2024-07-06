/**
 * Apex controller for privateViewContainer LWC.
 * @author Ben Learn
 * @since 02-16-2023
 * @group PrivateMixView
 */
public with sharing class PrivateViewController {
    /**
     * Method to retrieve names of mix categories, names of parent Recommended Badge Mixes, and privacy status of parent Recommended Badge Mixes.
     * @return  `List<Mix_Category__c>`
     */
    @AuraEnabled(cacheable=true)
    public static List<Mix_Category__c> getMixCategoryData() {
        List<Mix_Category__c> mixCategoryData = new MixCategoriesSelector().selectAllWithRecommendedBadgeMixInfos(Schema.SObjectType.Mix_Category__c.fieldSets.PrivateMixView);
        return mixCategoryData;
    }

    /**
     * Method to retrieve recommended badges for personal recommended badge mix.
     * @return  `Map<String, List<Recommended_Badge__c>>`
     */
    @AuraEnabled
    public static Map<String, List<Recommended_Badge__c>> getPrivateMixRecommendedBadges() {
        List<Recommended_Badge__c> privateMixRecommendedBadges = new RecommendedBadgesSelector().selectedAllRelatedToUserPrivateMix();
        if(privateMixRecommendedBadges.size() > 0) {
            Map<String, List<Recommended_Badge__c>> privateViewMap = new Map<String, List<Recommended_Badge__c>>();
            privateViewMap.put('High Priority', new List<Recommended_Badge__c>());

            List<Recommended_Badge__c> tempRecommendedBadges = new List<Recommended_Badge__c>();

            for(Recommended_Badge__c rb : privateMixRecommendedBadges) {
                if(rb.High_Priority__c) {
                    tempRecommendedBadges = privateViewMap.get('High Priority');
                    tempRecommendedBadges.add(rb);
                    privateViewMap.put('High Priority', tempRecommendedBadges);
                }

                if(privateViewMap.get(rb.Mix_Category__r.Name) != null) {
                    tempRecommendedBadges = privateViewMap.get(rb.Mix_Category__r.Name);
                    tempRecommendedBadges.add(rb);
                    privateViewMap.put(rb.Mix_Category__r.Name, tempRecommendedBadges);
                } else {
                    privateViewMap.put(rb.Mix_Category__r.Name, new List<Recommended_Badge__c>{rb});
                }
            }
            
            return privateViewMap;
            
        } else {
            return null;
        }
    }
}