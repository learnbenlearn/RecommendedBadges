@isTest
private class NewRecommendedBadgeTrailEventTgr_Tests {
    @isTest
    private static void it_should_queue_jobs_for_events() {
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(new Map<String, Object>{
            'generateMasterRecords' => false,
            'numberToGenerate' => 25
        });
        RecommendedTrailTS trailGenerator = new RecommendedTrailTS(new Map<String, Object>{
            'generateMasterRecords' => false,
            'numberToGenerate' => 25
        });
        List<Id> recordIDs = new List<Id>();
        recordIDs.addAll((new Map<Id, sObject>(badgeGenerator.generate())).keySet());
        recordIDs.addAll((new Map<Id, sObject>(trailGenerator.generate())).keySet());
        NewRecommendedBadgeTrailEventTS recordEventGenerator = new NewRecommendedBadgeTrailEventTS(
            new Map<String, Object>{'numberToGenerate' => 50}, 
            new List<TestSupport.TestDataField>{new ControlledValueField(NewRecommendedBadgeTrailEvent__e.RecordID__c, recordIDs)}
        );
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock('', 200));

        Test.startTest();
        EventBus.publish(recordEventGenerator.generate());
        Test.getEventBus().deliver();
        List<AsyncApexJob> queuedJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableTrailTrackerProviderCallout' AND JobType = 'Queueable' AND Status = 'Queued'];
        Assert.areEqual(50, queuedJobs.size(), 'Expected one queued Trail Tracker Provider for each NewRecommendedBadgeTrailEvent__e.');

        for(AsyncApexJob job : queuedJobs) {
            System.abortJob(job.Id);
        }
        Test.stopTest();
    }
}