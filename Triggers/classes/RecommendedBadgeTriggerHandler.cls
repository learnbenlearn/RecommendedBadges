/**
 * Trigger handler for Recommended_Badge__c object
 * @author Ben Learn
 * @since 06-10-2024
 */
public without sharing class RecommendedBadgeTriggerHandler extends TriggerHandler {
    /**
     * Constructor for trigger handler
     */    
    public RecommendedBadgeTriggerHandler() {
        super();
    }

    protected override void beforeInsert(List<sObject> newRecords) {
        RecommendedBadgeTrailTriggerHelper.updateURLPaths(Recommended_Badge__c.getSObjectType(), newRecords, null);
        populateBadgeMixKeys((List<Recommended_Badge__c>) newRecords, null);
    }

    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        RecommendedBadgeTrailTriggerHelper.queueTrailTrackerProviderCallouts(Recommended_Badge__c.getSObjectType(), newRecordsMap);
    }

    protected override void beforeUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) {
        RecommendedBadgeTrailTriggerHelper.updateURLPaths(Recommended_Badge__c.getSObjectType(), updatedRecordsMap.values(), oldRecordsMap);
        populateBadgeMixKeys((List<Recommended_Badge__c>) updatedRecordsMap.values(), (Map<Id, Recommended_Badge__c>) oldRecordsMap);
    }

    /**
     * Method to populate unique key in the format [Badge API Name]-[Recommended Badge Mix Name].
     * Done to ensure that there aren't any duplicated recommended badges within the same recommended badge mix.
     * @param newRecommendedBadges 
     * @param oldRecommendedBadgeMap 
     */    
    private static void populateBadgeMixKeys(List<Recommended_Badge__c> newRecommendedBadges, Map<Id, Recommended_Badge__c> oldRecommendedBadgeMap) {
        Set<Id> mixCategoryIds = new Set<Id>();

        for(Recommended_Badge__c newRecommendedBadge : newRecommendedBadges) {
            if(
                (newRecommendedBadge.Badge_Mix_Key__c == null) || 
                (oldRecommendedBadgeMap?.get(newRecommendedBadge.Id).Mix_Category__c != newRecommendedBadge.Mix_Category__c)
            ) {
                mixCategoryIds.add(newRecommendedBadge.Mix_Category__c);
            }
        }

        Map<Id, Mix_Category__c> mixCategoryMap = new Map<Id, Mix_Category__c>(new MixCategoriesSelector().selectByIdWithRecommendedBadgeMixNames(mixCategoryIds));
        for(Recommended_Badge__c newRecommendedBadge : newRecommendedBadges) {
            if(
                (newRecommendedBadge.Badge_Mix_Key__c == null) || 
                (oldRecommendedBadgeMap?.get(newRecommendedBadge.Id).Mix_Category__c != newRecommendedBadge.Mix_Category__c)
            ){
                String recommendedBadgeMixName = mixCategoryMap.get(newRecommendedBadge.Mix_Category__c).Recommended_Badge_Mix__r.Name;
                newRecommendedBadge.Badge_Mix_Key__c = newRecommendedBadge.BadgeAPIName__c + '-' + recommendedBadgeMixName;
            }
        }
    }
}