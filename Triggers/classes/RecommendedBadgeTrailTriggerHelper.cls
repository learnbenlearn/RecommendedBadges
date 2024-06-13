/**
 * Helper class for common functionality from RecommendedBadgeTriggerHandler and RecommendedTrailTriggerHandler.
 * @author Ben Learn
 * @since 06-10-2024
 */
public with sharing class RecommendedBadgeTrailTriggerHelper {
    /**
     * Enqueues Trail Tracker Provider callouts to get field values for new Recommended Badges/Recommended Trails. If size of newRecordsMap is greater than the remaining Apex
     * governor limits for enqueueing jobs in a single transaction, enqueues as many Trail Tracker Provider callouts as possible without violating the governor limit and publishes
     * NewRecommendedBadgeTrailEvent__e platform events for the remaining new records.
     * @param entityType type of values in newRecordsMap
     * @param newRecordsMap records to enqueue Trail Tracker Provider callouts/publish NewRecommendedBadgeTrailEvent__e events for
     */    
    public static void queueTrailTrackerProviderCallouts(SObjectType entityType, Map<Id, sObject> newRecordsMap) {
        Boolean failedEnqueueingJob = false;
        Integer remainingQueueableJobs = Limits.getLimitQueueableJobs() - Limits.getQueueableJobs();

        // not making callouts for Recommended Badges/Trails inserted through the Bulk API, which is currently only used for scratch org data population
        if(Request.getCurrent().getQuiddity() != Quiddity.BULK_API) {
            List<NewRecommendedBadgeTrailEvent__e> newRecordEvents = new List<NewRecommendedBadgeTrailEvent__e>();
            for(String newRecordId : newRecordsMap.keySet()) {
                if(remainingQueueableJobs > 0) {
                    try {
                        System.enqueueJob(new QueueableTrailTrackerProviderCallout(newRecordId));
                    } catch(Exception e) {
                        failedEnqueueingJob = true;
                        Logger.error(new LogMessage('Error enqueueing callout to Trail Tracker Provider. {0}: {1}. \n{2}', e.getTypeName(), e.getMessage(), e.getStackTraceString()));
                    }
                    remainingQueueableJobs -= 1;
                } else {
                    newRecordEvents.add(new NewRecommendedBadgeTrailEvent__e(RecordID__c = newRecordId));
                }
            }
            if(failedEnqueueingJob) {
                Logger.saveLog();
            }

            if(newRecordEvents.size() > 0) {
                List<Database.SaveResult> saveResults = EventBus.publish(newRecordEvents);
                DMLUtils.logErrors(saveResults, 'RecommendedBadgeTrailTriggerHelper');
            }
        }
    }
}