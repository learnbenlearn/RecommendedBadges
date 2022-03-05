/**
 * @description       : Apex controller for bensViewContainer LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 03-05-2022
 * @last modified by  : Ben Learn
**/
public with sharing class BensViewService {
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

    @AuraEnabled(cacheable=true)
    public static Map<String, List<Recommended_Badge__c>> getBensMixRecommendedBadges() {
        List<Recommended_Badge__c> bensMixRecommendedBadges = [SELECT Add_to_Recommended_Badges_Mix__c, Badge_Icon__c, 
            Category_Rank__c, High_Priority__c, Level__c, Report_URL__c, Time_Estimate_Minutes__c, Time_Estimate__c, Type__c, 
            Mix_Category__r.Name  FROM Recommended_Badge__c WHERE Mix_Category__r.Recommended_Badge_Mix__r.Name LIKE 'Ben%'
            ORDER BY Badge_Name__c];

        Map<String, List<Recommended_Badge__c>> bensViewMap = new Map<String, List<Recommended_Badge__c>>();
        bensViewMap.put('High Priority', new List<Recommended_Badge__c>());
        bensViewMap.put('Add to Recommended Badges Mix', new List<Recommended_Badge__c>());

        List<Recommended_Badge__c> tempRecommendedBadges = new List<Recommended_Badge__c>();

        System.debug(bensMixRecommendedBadges);
        for(Recommended_Badge__c rb : bensMixRecommendedBadges) {
            if(rb.High_Priority__c) {
                tempRecommendedBadges = bensViewMap.get('High Priority');
                tempRecommendedBadges.add(rb);
                bensViewMap.put('High Priority', tempRecommendedBadges);
            }

            if(rb.Add_to_Recommended_Badges_Mix__c) {
                tempRecommendedBadges = bensViewMap.get('Add to Recommended Badges');
                tempRecommendedBadges.add(rb);
                bensViewMap.put('Add to Recommended Badges', tempRecommendedBadges);
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