@isTest
private class RecommendedTrailTrigger_Tests {
    @testSetup
    private static void generateData(){
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(
            new Map<String, Object> {'generateRecordIDs' => false, 'numberToGenerate' => 1},
            new List<TestSupport.TestDataField>{new TestSupport.TestDataField(Recommended_Badge_Mix__c.Private_Mix__c, true)}
        );        insert badgeMixGenerator.generate();
        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object> {'generateRecordIDs' => false, 'numberToGenerate' => 50},
            new List<TestSupport.TestDataField>{
                new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, sObject>(badgeMixGenerator.records)).keySet())
            }
        );
        insert mixCategoryGenerator.generate();
    }

    @isTest
    private static void it_should_enqueue_jobs() {
        RecommendedTrailTS trailGenerator = new RecommendedTrailTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false,
                'numberToGenerate' => Limits.getLimitQueueableJobs()
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Trail__c.Mix_Category__c, (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet())
            }
        );
        
        Test.startTest();
        RecommendedBadgeTrailTriggerHelper.enabledForTesting = true;
        insert trailGenerator.generate();
        List<AsyncApexJob> queuedJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableTrailTrackerProviderCallout' AND JobType = 'Queueable' AND Status = 'Queued'];
        Assert.areEqual(trailGenerator.records.size(), queuedJobs.size(), 'Expected one queued Trail Tracker Provider callout per Recommended Trail.');

        cleanup(queuedJobs, false);
        Test.stopTest();
    }

    @isTest
    private static void it_should_enqueue_jobs_and_publish_record_events() {
        RecommendedTrailTS trailGenerator = new RecommendedTrailTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Trail__c.Mix_Category__c, (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet())
            }
        );
        
        Test.startTest();

        RecommendedBadgeTrailTriggerHelper.enabledForTesting = true;
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

        cleanup(queuedJobs, true);
        Test.stopTest();
    }

    @isTest
    private static void it_should_update_urls_for_new_trails() {
        Integer numberToGenerate = 100;
        RecommendedTrailTS trailGenerator = new RecommendedTrailTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false,
                'generatorReturnValue' => 'all',
                'numberToGenerate' => numberToGenerate
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Trail__c.Mix_Category__c, (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet()),
                new CounterSuffixField(Recommended_Trail__c.URL__c, RecommendedBadgeTrailTriggerHelper.TRAILHEAD_URL_MAPPINGS.get('Trail').defaultPath + '/Test_Trail_')
            }
        );
        trailGenerator.generate();
        List<Recommended_Trail__c> testTrails = (List<Recommended_Trail__c>) trailGenerator.setFieldSpec(new TestSupport.TestDataField(Recommended_Trail__c.URL__c, '')).generate();

        Test.startTest();
        insert testTrails;
        Test.stopTest();

        testTrails = [SELECT Id, TrailAPIName__c, URL__c FROM Recommended_Trail__c];
        String trailPath = RecommendedBadgeTrailTriggerHelper.TRAILHEAD_URL_MAPPINGS.get('Trail').trailheadPath;
        Integer numNullURLs = 0;
        for(Recommended_Trail__c trail : testTrails) {
            if(trail.URL__c == null) {
                numNullURLs++;
            } else {
                Assert.areEqual(
                    trailPath + '/' + trail.TrailAPIName__c,
                    trail.URL__c,
                    'Expected URL to be updated to Trailhead path from default path.'
                );
            }
        }
        Assert.areEqual(numberToGenerate, numNullURLs, 'Expected null URL to be unchanged by RecommendedBadgeTrailTriggerHelper.updateURLPaths().');
    }

    @isTest
    private static void it_should_update_urls_for_updated_trails() {
        String testURL = 'www.test.com';
        List<Recommended_Trail__c> testTrails = (List<Recommended_Trail__c>) new RecommendedTrailTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Trail__c.Mix_Category__c, (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet()),
                new TestSupport.TestDataField(Recommended_Trail__c.URL__c, testURL)
            }
        ).generate();
        insert testTrails;

        Integer counter = 0;
        String defaultTrailPath = RecommendedBadgeTrailTriggerHelper.TRAILHEAD_URL_MAPPINGS.get('Trail').defaultPath;
        for(Recommended_Trail__c trail : testTrails) {
            if(counter < 150) {
                trail.URL__c = defaultTrailPath + '/' + trail.TrailAPIName__c;
                counter++;
            }
            trail.Description__c = 'Updated description.';
        }

        Test.startTest();
        update testTrails;
        Test.stopTest();

        testTrails = [SELECT Id, TrailAPIName__c, URL__c FROM Recommended_Trail__c];
        Integer numUnchangedURLs = 0;
        String trailPath = RecommendedBadgeTrailTriggerHelper.TRAILHEAD_URL_MAPPINGS.get('Trail').trailheadPath;
        for(Recommended_Trail__c trail : testTrails) {
            if(trail.URL__c == testURL) {
                numUnchangedURLs++;
            } else {
                Assert.areEqual(trailPath + '/' + trail.TrailAPIName__c, trail.URL__c, 'Expected URL to be updated to Trailhead path from default path.');
            }
        }
        Assert.areEqual(50, numUnchangedURLs, 'Expected unchanged URL to be unchanged by RecommendedBadgeTrailTriggerHelper.updateURLPaths().');
    }

    private static void cleanup(List<AsyncApexJob> jobs, Boolean failEventDelivery) {
        if(failEventDelivery) {
            Test.getEventBus().fail();
        }
        for(AsyncApexJob job : jobs) {
            System.abortJob(job.Id);
        }
    }
}