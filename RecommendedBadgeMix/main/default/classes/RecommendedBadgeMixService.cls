/**
 * @description       : Apex controller for recommendedBadgeMixContainer LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 03-11-2022
 * @last modified by  : Ben Learn
**/
public without sharing class RecommendedBadgeMixService {
    @AuraEnabled(cacheable=true)
    public static SetupDataWrapper getSetupData() {
        List<Mix_Category__c> mixCategories = [SELECT Name, Recommended_Badge_Mix__r.Name, (SELECT Description__c,
            Level__c, Trail_Name__c, URL__c FROM Recommended_Trails__r WHERE Archived__c = false), (SELECT
            Badge_Name__c, Description__c, Level__c, Type__c, URL__c FROM Recommended_Badges__r WHERE Archived__c = false) FROM 
            Mix_Category__c WHERE Recommended_Badge_Mix__r.Private_Mix__c = false ORDER BY Name];

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

        List<Recommended_Badge_Mix__c> defaultMix = [SELECT Name FROM Recommended_Badge_Mix__c WHERE Default_Badge_Mix__c = true];
        
        SetupDataWrapper setupData = new SetupDataWrapper(categoriesByMix, defaultMix[0].Name);

        return setupData;
    }
}