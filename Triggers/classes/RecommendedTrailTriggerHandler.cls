/**
 * Trigger handler for Recommended_Trail__c object
 * @author Ben Learn
 * @since 06-10-2024
 */
public without sharing class RecommendedTrailTriggerHandler extends TriggerHandler {
    /**
     * Constructor for trigger handler
     */    
    public RecommendedTrailTriggerHandler() {
        super();
    }

    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        RecommendedBadgeTrailTriggerHelper.queueTrailTrackerProviderCallouts(Recommended_Badge__c.getSObjectType(), newRecordsMap);
    }
}