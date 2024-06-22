/**
 * Helper class for common functionality from RecommendedBadgeTriggerHandler and RecommendedTrailTriggerHandler.
 * @author Ben Learn
 * @since 06-10-2024
 */
public with sharing class RecommendedBadgeTrailTriggerHelper {
    @TestVisible
    private static Boolean enabledForTesting = false;

    @TestVisible
    private static final Map<String, URLMapping> TRAILHEAD_URL_MAPPINGS {
        get {
            if(TRAILHEAD_URL_MAPPINGS == null) {
                TRAILHEAD_URL_MAPPINGS = new Map<String, URLMapping>();
                List<TrailheadEntityURLMapping__mdt> urlMappings = [SELECT DefaultPath__c, TrailheadEntityType__c, TrailheadPath__c FROM TrailheadEntityURLMapping__mdt];
                for(TrailheadEntityURLMapping__mdt urlMapping : urlMappings) {
                    TRAILHEAD_URL_MAPPINGS.put(
                        urlMapping.TrailheadEntityType__c, 
                        new URLMapping(urlMapping.TrailheadEntityType__c, urlMapping.DefaultPath__c, urlMapping.TrailheadPath__c)
                    );
                }
            }
            return TRAILHEAD_URL_MAPPINGS;
        }
        set;
    }

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
        if((Request.getCurrent().getQuiddity() == Quiddity.BULK_API) || (Test.isRunningTest() && !enabledForTesting)) {
            return;
        }
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

    /**
     * Updates the value of the URL__c field on Recommended Badges/Trails from the https://developer.salesforce.com domain to the https://trailhead.salesforce.com domain.
     * @param entityType type of values in newRecords and oldRecordsMap
     * @param newRecords
     * @param oldRecordsMap 
     */    
    public static void updateURLPaths(SObjectType entityType, List<sObject> newRecords, Map<Id, sObject> oldRecordsMap) {
        if(oldRecordsMap == null) {
            for(sObject newRecord : newRecords) {
                if(newRecord.get('URL__c') != null) {
                    changeURL(entityType, newRecord);
                }
            }
        } else {
            for(sObject newRecord : newRecords) {
                if(newRecord.get('URL__c') != oldRecordsMap.get(String.valueOf(newRecord.get('Id'))).get('URL__c')) {
                    changeURL(entityType, newRecord);
                }
            }
        }
    }

    private static void changeURL(SObjectType entityType, sObject record) {
        URLMapping mapping = TRAILHEAD_URL_MAPPINGS.get(entityType.getDescribe().getName() == 'Recommended_Trail__c' ? 'Trail' : String.valueOf(record.get('Type__c')));
        record.put('URL__c', String.valueOf(record.get('URL__c')).replace(mapping.defaultPath, mapping.trailheadPath));
    }

    @TestVisible
    private class URLMapping {
        @TestVisible
        private String trailheadEntityType;
        @TestVisible
        private String defaultPath;
        @TestVisible
        private String trailheadPath;

        private URLMapping(String trailheadEntityType, String defaultPath, String trailheadPath) {
            this.trailheadEntityType = trailheadEntityType;
            this.defaultPath = defaultPath;
            this.trailheadPath = trailheadPath;
        }
    }
}