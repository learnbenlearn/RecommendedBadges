@isTest
private class RecommendedTrailTrigger_Tests {
    @isTest
    private static void it_should_enqueue_jobs() {
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object> {
            'generateRecordIDs' => false,
            'numberToGenerate' => 1
        });
        insert badgeMixGenerator.generate();
        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object> {'generateRecordIDs' => false, 'numberToGenerate' => 50},
            new List<TestSupport.TestDataField>{
                new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, sObject>(badgeMixGenerator.records)).keySet())
            }
        );
        insert mixCategoryGenerator.generate();
        RecommendedTrailTS trailGenerator = new RecommendedTrailTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false,
                'numberToGenerate' => Limits.getLimitQueueableJobs()
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Trail__c.Mix_Category__c, (new Map<Id, sObject>(mixCategoryGenerator.records)).keySet())
            }
        );
        
        Test.startTest();
        insert trailGenerator.generate();
        List<AsyncApexJob> queuedJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableTrailTrackerProviderCallout' AND JobType = 'Queueable' AND Status = 'Queued'];
        Assert.areEqual(trailGenerator.records.size(), queuedJobs.size(), 'Expected one queued Trail Tracker Provider callout per Recommended Trail.');

        // clean up
        for(AsyncApexJob queuedJob : queuedJobs) {
            System.abortJob(queuedJob.Id);
        }
        Test.stopTest();
    }

    @isTest
    private static void it_should_enqueue_jobs_and_publish_record_events() {
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(
            new Map<String, Object> {'generateRecordIDs' => false, 'numberToGenerate' => 1},
            new List<TestSupport.TestDataField>{new TestSupport.TestDataField(Recommended_Badge_Mix__c.Private_Mix__c, true)}
        );
        insert badgeMixGenerator.generate();
        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object> {'generateRecordIDs' => false, 'numberToGenerate' => 50},
            new List<TestSupport.TestDataField>{
                new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, sObject>(badgeMixGenerator.records)).keySet())
            }
        );
        insert mixCategoryGenerator.generate();
        RecommendedTrailTS trailGenerator = new RecommendedTrailTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Trail__c.Mix_Category__c, (new Map<Id, sObject>(mixCategoryGenerator.records)).keySet())
            }
        );
        
        Test.startTest();

        insert trailGenerator.generate();
        
        List<AsyncApexJob> queuedJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableTrailTrackerProviderCallout' AND JobType = 'Queueable' AND Status = 'Queued'];
        Integer numPublishedRecordEvents = Limits.getDmlRows() - trailGenerator.records.size();

        Assert.areEqual(
            Limits.getLimitQueueableJobs(), 
            queuedJobs.size(), 
            'Expected the number of queued Trail Tracker Provider callouts to equal the Apex governor on queued jobs.'
        );
        Assert.areEqual(
            2,
            Limits.getDmlStatements(), 
            'Expected two DML statements - one to insert Recommended Trails and one to publish NewRecommendedBadgeTrailEvent__e platform events.'
        );
        Assert.areEqual(
            trailGenerator.records.size() - Limits.getLimitQueueableJobs(), 
            numPublishedRecordEvents, 
            'Expected the number of published NewRecommendedBadgeTrailEvent__e events to equal the number of Recommended Trails minus the Apex governor limit on queued jobs.'
        );

        // cleanup
        for(AsyncApexJob queuedJob : queuedJobs) {
            System.abortJob(queuedJob.Id);
        }
        Test.getEventBus().fail();
        Test.stopTest();
    }
}