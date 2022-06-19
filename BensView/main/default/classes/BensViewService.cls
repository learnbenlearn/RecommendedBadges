/**
 * @description       : Apex controller for bensViewContainer LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 06-18-2022
 * @last modified by  : Ben Learn
**/
public with sharing class BensViewService {
    /**
    * @description Method to retrieve names of mix categories for personal recommended badge mix.
    * @author Ben Learn | 03-11-2022 
    * @return List<String> 
    **/
    @AuraEnabled(cacheable=true)
    public static Map<String, Mix_Category__c> getBensMixCategoryNames() {
        List<Mix_Category__c> bensMixCategories = [SELECT Name FROM Mix_Category__c WHERE Recommended_Badge_Mix__r.Name LIKE 'Ben%'
            ORDER BY Name];

        List<Mix_Category__c> publicMixCategories = [SELECT Name, Recommended_Badge_Mix__r.Name FROM Mix_Category__c WHERE 
            NOT Recommended_Badge_Mix__r.Name LIKE 'Ben%'];

        List<String> bensMixCategoryNames = new List<String>();
        for(Mix_Category__c mc : bensMixCategories) {
            bensMixCategoryNames.add(mc.Name);
        }

        //bensMixCa
        return bensMixCategoryNames;
    }

    /**
    * @description Method to retrieve recommended badges for personal recommended badge mix.
    * @author Ben Learn | 03-11-2022 
    * @return Map<String, List<Recommended_Badge__c>> 
    **/
    @AuraEnabled
    public static Map<String, List<Recommended_Badge__c>> getBensMixRecommendedBadges() {
        List<Recommended_Badge__c> bensMixRecommendedBadges = [SELECT Badge_Name__c, Category_Rank__c, High_Priority__c, 
            High_Priority_Id__c, Level__c, Time_Estimate_Minutes__c, Time_Estimate__c, Type__c, URL__c,Mix_Category__r.Name
            FROM Recommended_Badge__c WHERE Mix_Category__r.Recommended_Badge_Mix__r.Name LIKE 'Ben%' ORDER BY Badge_Name__c];

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

        System.debug(bensViewMap.get('High Priority'));

        return bensViewMap;
    }

    /**
    * @description Method to delete recommended badge based on Id.
    * @author Ben Learn | 06-17-2022 
    * @param Id recommendedBadgeId 
    **/
    @AuraEnabled
    public static void deleteRecommendedBadge(Id recommendedBadgeId) {
        List<Recommended_Badge__c> recommendedBadges = [SELECT Id FROM Recommended_Badge__c WHERE Id = :recommendedBadgeId];
        delete recommendedBadges;
    }
}