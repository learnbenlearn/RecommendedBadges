/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-25-2022
 * @last modified by  : Ben Learn
**/
public without sharing class RecommendedBadgeMixService {
    @AuraEnabled(cacheable=true)
    public static List<Mix_Category__c> getSetupData() {
        List<Mix_Category__c> mixCategories = [SELECT Name, Recommended_Badge_Mix__r.Name, (SELECT Name, Badge_Icon__c, Description__c,
            Level__c, Trail_Name__c, URL__c FROM Recommended_Trails__r WHERE Archived__c = false), (SELECT Name, Badge_Icon__c, 
            Badge_Name__c, Description__c, Level__c, Mix_Category__c, Type__c, URL__c FROM Recommended_Badges__r WHERE 
            Archived__c = false) FROM Mix_Category__c];

        return mixCategories;
    }

    public class SetupDataWrapper {

    }
}