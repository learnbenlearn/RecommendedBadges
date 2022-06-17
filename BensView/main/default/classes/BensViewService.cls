/**
 * @description       : Apex controller for bensViewContainer LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 06-16-2022
 * @last modified by  : Ben Learn
**/
public with sharing class BensViewService {
    /**
    * @description Method to retrieve names of mix categories for personal recommended badge mix.
    * @author Ben Learn | 03-11-2022 
    * @return List<String> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<String> getBensMixCategoryNames() {
        List<Mix_Category__c> bensMixCategories = [SELECT Name FROM Mix_Category__c WHERE Recommended_Badge_Mix__r.Name LIKE 'Ben%'
            ORDER BY Name];

        List<String> bensMixCategoryNames = new List<String>();
        for(Mix_Category__c mc : bensMixCategories) {
            bensMixCategoryNames.add(mc.Name);
        }

        return bensMixCategoryNames;
    }

    /**
    * @description Method to retrieve recommended badges for personal recommended badge mix.
    * @author Ben Learn | 03-11-2022 
    * @return Map<String, List<Recommended_Badge__c>> 
    **/
    @AuraEnabled(cacheable=true)
    public static Map<String, List<Recommended_Badge__c>> getBensMixRecommendedBadges() {
        List<Recommended_Badge__c> bensMixRecommendedBadges = [SELECT Badge_Name__c,Category_Rank__c, High_Priority__c, Level__c,
            Time_Estimate_Minutes__c, Time_Estimate__c, Type__c, URL__c,Mix_Category__r.Name  FROM Recommended_Badge__c WHERE 
            Mix_Category__r.Recommended_Badge_Mix__r.Name LIKE 'Ben%' ORDER BY Badge_Name__c];

        Map<String, List<Recommended_Badge__c>> bensViewMap = new Map<String, List<Recommended_Badge__c>>();
        bensViewMap.put('High Priority', new List<Recommended_Badge__c>());

        List<Recommended_Badge__c> tempRecommendedBadges = new List<Recommended_Badge__c>();

        for(Recommended_Badge__c rb : bensMixRecommendedBadges) {
            if(rb.High_Priority__c) {
                tempRecommendedBadges = bensViewMap.get('High Priority');
                tempRecommendedBadges.add(rb);
                bensViewMap.put('High Priority', tempRecommendedBadges);
            }

            if(bensViewMap.get(rb.Mix_Category__r.Name) != null) {
                tempRecommendedBadges = bensViewMap.get(rb.Mix_Category__r.Name);
            } else {
                tempRecommendedBadges = new List<Recommended_Badge__c>();
            }

            tempRecommendedBadges.add(rb);
            bensViewMap.put(rb.Mix_Category__r.Name, tempRecommendedBadges);
        }

        return bensViewMap;
    }
}