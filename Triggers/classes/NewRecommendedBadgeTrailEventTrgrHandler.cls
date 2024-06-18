/**
 * Trigger handler for NewRecommendedBadgeTrailEvent__e platform event.
 * @author Ben Learn
 * @since 06-10-2024
 */
public with sharing class NewRecommendedBadgeTrailEventTrgrHandler extends TriggerHandler {
    /**
     * Constructor for trigger handler.
     */    
    public NewRecommendedBadgeTrailEventTrgrHandler() {
        super();
    }

    /**
     * Enqueues Trail Tracker Provider callouts to retrieve field values for new Recommended Badge/Recommended Trail records.
     * @param newRecordsMap 
     */    
    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        for(String newRecordId : newRecordsMap.keySet()) {
            try {
                System.enqueueJob(new QueueableTrailTrackerProviderCallout(newRecordId));
            } catch(Exception e) {
                Logger.error(new LogMessage('Error enqueueing callout to Trail Tracker Provider. {0}: {1}. \n{2}', e.getTypeName(), e.getMessage(), e.getStackTraceString()));
            }
        }
        Logger.saveLog();
    }
}