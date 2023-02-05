/**
 * @description       : Apex controller for privateViewContainer LWC.
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
 * @last modified by  : Ben Learn
**/
public with sharing class PrivateViewController {

    /**
    * @description Method to retrieve names of mix categories, names of parent Recommended Badge Mixes, and privacy status of parent Recommended Badge Mixes.
    * @author Ben Learn | 03-11-2022 
    * @return List<Mix_Category__c> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Mix_Category__c> getMixCategoryData() {
        List<Mix_Category__c> mixCategoryData = new MixCategoriesSelector().selectAllWithRecommendedBadgeMixInfos(Schema.SObjectType.Mix_Category__c.fieldSets.PrivateMixView);
        return mixCategoryData;
    }

    /**
    * @description Method to retrieve recommended badges for personal recommended badge mix.
    * @author Ben Learn | 03-11-2022 
    * @return Map<String, List<Recommended_Badge__c>> 
    **/
    @AuraEnabled
    public static Map<String, List<Recommended_Badge__c>> getPrivateMixRecommendedBadges() {
        List<Recommended_Badge__c> privateMixRecommendedBadges = new RecommendedBadgesSelector().selectAllRelatedToPrivateRecommendedBadgeMixes();
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
    }
}