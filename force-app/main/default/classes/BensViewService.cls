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
}