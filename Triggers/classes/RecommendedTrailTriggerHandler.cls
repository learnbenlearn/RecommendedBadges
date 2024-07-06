/**
 * Trigger handler for Recommended_Trail__c object
 * @author Ben Learn
 * @since 06-10-2024
 * @group Triggers
 */
public without sharing class RecommendedTrailTriggerHandler extends TriggerHandler {
    /**
     * Constructor for trigger handler
     */    
    public RecommendedTrailTriggerHandler() {
        super();
    }

    protected override void beforeInsert(List<sObject> newRecords) {
        RecommendedBadgeTrailTriggerHelper.updateURLPaths(Recommended_Trail__c.getSObjectType(), newRecords, null);
    }

    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        RecommendedBadgeTrailTriggerHelper.queueTrailTrackerProviderCallouts(Recommended_Trail__c.getSObjectType(), newRecordsMap);
    }

    protected override void beforeUpdate(Map<Id, SObject> updatedRecordsMap, Map<Id, SObject> oldRecordsMap) {
        RecommendedBadgeTrailTriggerHelper.updateURLPaths(Recommended_Trail__c.getSObjectType(), updatedRecordsMap.values(), oldRecordsMap);
    }
}