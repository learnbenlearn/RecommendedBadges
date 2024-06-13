@isTest
private class RecommendedBadgeTrailTriggerHelper_Tests {
    @isTest
    private static void it_should_enqueue_jobs_for_badges() {
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(new Map<String, Object> {
            'generateMasterRecords' => false,
            'useFieldDefaults' => false,
            'numberToGenerate' => Limits.getLimitQueueableJobs()
        });
        
        Test.startTest();
        RecommendedBadgeTrailTriggerHelper.queueTrailTrackerProviderCallouts(Recommended_Badge__c.getSObjectType(), new Map<Id, sObject>(badgeGenerator.generate()));
        List<AsyncApexJob> queuedJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableTrailTrackerProviderCallout' AND JobType = 'Queueable' AND Status = 'Queued'];
        Assert.areEqual(badgeGenerator.records.size(), queuedJobs.size(), 'Expected one queued Trail Tracker Provider callout per Recommended Badge.');
        for(AsyncApexJob queuedJob : queuedJobs) {
            System.abortJob(queuedJob.Id);
        }
        Test.stopTest();
    }

    @isTest
    private static void it_should_enqueue_jobs_for_trails() {
        RecommendedTrailTS trailGenerator = new RecommendedTrailTS(new Map<String, Object> {
            'generateMasterRecords' => false,
            'useFieldDefaults' => false,
            'numberToGenerate' => Limits.getLimitQueueableJobs()
        });
        
        Test.startTest();
        RecommendedBadgeTrailTriggerHelper.queueTrailTrackerProviderCallouts(Recommended_Trail__c.getSObjectType(), new Map<Id, sObject>(trailGenerator.generate()));
        List<AsyncApexJob> queuedJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableTrailTrackerProviderCallout' AND JobType = 'Queueable' AND Status = 'Queued'];
        Assert.areEqual(trailGenerator.records.size(), queuedJobs.size(), 'Expected one queued Trail Tracker Provider callout per Recommended Trail.');
        for(AsyncApexJob queuedJob : queuedJobs) {
            System.abortJob(queuedJob.Id);
        }
        Test.stopTest();
    }

    @isTest
    private static void it_should_enqueue_jobs_and_publish_record_events_for_badges() {
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(new Map<String, Object> {
            'generateMasterRecords' => false,
            'useFieldDefaults' => false
        });
        
        Test.startTest();
        RecommendedBadgeTrailTriggerHelper.queueTrailTrackerProviderCallouts(Recommended_Badge__c.getSObjectType(), new Map<Id, sObject>(badgeGenerator.generate()));
        List<AsyncApexJob> queuedJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableTrailTrackerProviderCallout' AND JobType = 'Queueable' AND Status = 'Queued'];

        Assert.areEqual(
            Limits.getLimitQueueableJobs(), 
            queuedJobs.size(), 
            'Expected the number of queued Trail Tracker Provider callouts to equal the Apex governor on queued jobs.'
        );
        Assert.areEqual(1, Limits.getDmlStatements(), 'Expected one DML statement to publish NewRecommendedBadgeTrailEvent__e platform events.');
        Assert.areEqual(
            badgeGenerator.records.size() - Limits.getLimitQueueableJobs(), 
            Limits.getDmlRows(), 
            'Expected the number of published NewRecommendedBadgeTrailEvent__e events to equal the number of Recommended Badges minus the Apex governor limit on queued jobs.'
        );
        for(AsyncApexJob queuedJob : queuedJobs) {
            System.abortJob(queuedJob.Id);
        }
        Test.stopTest();
    }

    @isTest
    private static void it_should_enqueue_jobs_and_publish_record_events_for_trails() {
        RecommendedTrailTS trailGenerator = new RecommendedTrailTS(new Map<String, Object> {
            'generateMasterRecords' => false,
            'useFieldDefaults' => false
        });
        
        Test.startTest();
        RecommendedBadgeTrailTriggerHelper.queueTrailTrackerProviderCallouts(Recommended_Trail__c.getSObjectType(), new Map<Id, sObject>(trailGenerator.generate()));
        List<AsyncApexJob> queuedJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableTrailTrackerProviderCallout' AND JobType = 'Queueable' AND Status = 'Queued'];

        Assert.areEqual(
            Limits.getLimitQueueableJobs(), 
            queuedJobs.size(), 
            'Expected the number of queued Trail Tracker Provider callouts to equal the Apex governor on queued jobs.'
        );
        Assert.areEqual(1, Limits.getDmlStatements(), 'Expected one DML statement to publish NewRecommendedBadgeTrailEvent__e platform events.');
        Assert.areEqual(
            trailGenerator.records.size() - Limits.getLimitQueueableJobs(), 
            Limits.getDmlRows(), 
            'Expected the number of published NewRecommendedBadgeTrailEvent__e events to equal the number of Recommended Trails minus the Apex governor limit on queued jobs.'
        );
        for(AsyncApexJob queuedJob : queuedJobs) {
            System.abortJob(queuedJob.Id);
        }
        Test.stopTest();
    }
}