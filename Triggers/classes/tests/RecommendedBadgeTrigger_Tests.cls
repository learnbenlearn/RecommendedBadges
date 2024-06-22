@isTest
private class RecommendedBadgeTrigger_Tests {
    @testSetup
    private static void generateData(){
        TestDataFactory.RecommendedBadgeMix recommendedBadgeMixGenerator = new TestDataFactory.RecommendedBadgeMix(true, true, 1, false, true);
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = recommendedBadgeMixGenerator.execute();

        TestDataFactory.MixCategory mixCategoryGenerator = new TestDataFactory.MixCategory(true, false, 1, testRecommendedBadgeMixes);
        mixCategoryGenerator.execute();
    }

    @isTest
    private static void testPopulateBadgeMixKeys_singlePositiveInsert() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];

        try {
            Test.startTest();
            List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
                new Recommended_Badge__c(
                    Mix_Category__c=testMixCategories[0].Id,
                    BadgeAPIName__c='Test_Badge_1'
                )
            };
            insert testRecommendedBadges;
            Test.stopTest();
        } catch(Exception e) {
            Assert.fail('No exception expected.');
        }
    }

    @isTest
    private static void testPopulateBadgeMixKeys_bulkPositiveInsert() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];

        try {
            Test.startTest();
            TestDataFactory.RecommendedBadge recommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(
                true, false, new List<Mix_Category__c>{testMixCategories[0]}, true
            );
            recommendedBadgeGenerator.execute();
            Test.stopTest();
        } catch(Exception e) {
            Assert.fail('No exception expected.');
        }
    }

    @isTest
    private static void testPopulateBadgeMixKeys_negativeInsert() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        for(Integer i = 0; i < 2; i++) {
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                BadgeAPIName__c='Test_Badge_1'
            ));
        }

        try {
            Test.startTest();
            insert testRecommendedBadges;
            Test.stopTest();
            Assert.fail('Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        } catch(Exception e) {
            Assert.isTrue(e.getMessage().contains('DUPLICATE_VALUE'), 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        }
    }

    @isTest
    private static void testPopulateBadgeMixKeys_bulkNegativeInsert() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];

        TestDataFactory.RecommendedBadge recommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(
            false, true, new List<Mix_Category__c>{testMixCategories[0]}, true
        );
        List<Recommended_Badge__c> testRecommendedBadges = recommendedBadgeGenerator.execute();
        testRecommendedBadges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[0].Id,
            BadgeAPIName__c='Test_Badge_' + Integer.valueOf(Math.floor(Math.random() * testRecommendedBadges.size()))
        ));

        try {
            Test.startTest();
            insert testRecommendedBadges;
            Test.stopTest();
            Assert.fail('Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        } catch(Exception e) {
            Assert.isTrue(e.getMessage().contains('DUPLICATE_VALUE'), 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        }
    }
    
    @isTest
    private static void testPopulateBadgeMixKeys_singlePositiveUpdate() {
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = [SELECT Id FROM Recommended_Badge_Mix__c];

        List<Mix_Category__c> testMixCategories = new List<Mix_Category__c>{    
            new Mix_Category__c(
                Name='Test Mix Category',
                Recommended_Badge_Mix__c=testRecommendedBadgeMixes[0].Id
            ),
            new Mix_Category__c(
                Name='Test Mix Category 2',
                Recommended_Badge_Mix__c=testRecommendedBadgeMixes[0].Id
            )
        };
        insert testMixCategories;

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
            new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                BadgeAPIName__c='Test_Badge_1'
            )
        };

        try {
            Test.startTest();
            insert testRecommendedBadges;

            testRecommendedBadges[0].Mix_Category__c=testMixCategories[1].Id;
            update testRecommendedBadges;
            Test.stopTest();
        } catch(Exception e) {
            Assert.fail('No exception expected.');
        }
    }

    @isTest
    private static void testPopulateBadgeMixKeys_bulkPositiveUpdate() {
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = [SELECT Id FROM Recommended_Badge_Mix__c];

        List<Mix_Category__c> testMixCategories = new List<Mix_Category__c>{ 
            new Mix_Category__c(
                Name='Test Mix Category',
                Recommended_Badge_Mix__c=testRecommendedBadgeMixes[0].Id
            )
        };
        insert testMixCategories;

        testMixCategories = [SELECT Id FROM Mix_Category__c];
        
        TestDataFactory.RecommendedBadge recommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(false, true, new List<Mix_Category__c>{testMixCategories[0]}, true);
        List<Recommended_Badge__c> testRecommendedBadges = recommendedBadgeGenerator.execute();

        try {
            Test.startTest();
            insert testRecommendedBadges;

            for(Integer i = 0; i < 200; i++) {
                testRecommendedBadges[i].Mix_Category__c = testMixCategories[1].Id;
            }

            update testRecommendedBadges;
            Test.stopTest();
        } catch(Exception e) {
            Assert.fail('No exception expected.');
        }
    }

    @isTest
    private static void testPopulateBadgeMixKeys_negativeUpdate() {
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = new List<Recommended_Badge_Mix__c>{
            new Recommended_Badge_Mix__c(
                Name='Test Recommended Badge Mix'
            )
        };
        insert testRecommendedBadgeMixes;

        List<Mix_Category__c> testMixCategories = new List<Mix_Category__c>{
            new Mix_Category__c(
                Name='Test Mix Category',
                Recommended_Badge_Mix__c=testRecommendedBadgeMixes[0].Id
            )
        };
        insert testMixCategories;
        testMixCategories = [SELECT Id FROM Mix_Category__c];

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        testRecommendedBadges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[0].Id,
            BadgeAPIName__c='Test_Badge_1'
        ));
        testRecommendedBadges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[1].Id,
            BadgeAPIName__c='Test_Badge_1'
        ));

        try {
            Test.startTest();
            insert testRecommendedBadges;

            testRecommendedBadges[0].Mix_Category__c = testRecommendedBadges[1].Mix_Category__c;
            update testRecommendedBadges;
            Test.stopTest();
            Assert.fail('Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        } catch(Exception e) {
            Assert.isTrue(e.getMessage().contains('DUPLICATE_VALUE'), 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        }
    }

    @isTest
    private static void testPopulateBadgeMixKeys_negativeBulkUpdate() {
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = new List<Recommended_Badge_Mix__c>{
            new Recommended_Badge_Mix__c(
                Name='Test Recommended Badge Mix'
            )
        };
        insert testRecommendedBadgeMixes;

        List<Mix_Category__c> testMixCategories = new List<Mix_Category__c>{
            new Mix_Category__c(
                Name='Test Mix Category',
                Recommended_Badge_Mix__c=testRecommendedBadgeMixes[0].Id
            )
        };
        insert testMixCategories;
        testMixCategories = [SELECT Id FROM Mix_Category__c];

        TestDataFactory.RecommendedBadge recommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(
            false, true, new List<Mix_Category__c>{testMixCategories[0]}, true
        );
        List<Recommended_Badge__c> testRecommendedBadges = recommendedBadgeGenerator.execute();
        TestDataFactory.RecommendedBadge duplicateRecommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(
            false, true, new List<Mix_Category__c>{testMixCategories[1]}, true
        );
        testRecommendedBadges.addAll((List<Recommended_Badge__c>) duplicateRecommendedBadgeGenerator.execute());

        try {
            Test.startTest();
            insert testRecommendedBadges;
            
            for(Recommended_Badge__c rb : testRecommendedBadges) {
                if(rb.Mix_Category__c == testMixCategories[0].Id) {
                    rb.Mix_Category__c = testMixCategories[1].Id;
                }
            }
            update testRecommendedBadges;
            Test.stopTest();
            Assert.fail('Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        } catch(Exception e) {
            Assert.isTrue(e.getMessage().contains('DUPLICATE_VALUE'), 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        }
    }

    @isTest
    private static void it_should_enqueue_jobs() {
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false,
                'numberToGenerate' => Limits.getLimitQueueableJobs()
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet())
            }
        );
        
        Test.startTest();
        RecommendedBadgeTrailTriggerHelper.enabledForTesting = true;
        insert badgeGenerator.generate();
        List<AsyncApexJob> queuedJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableTrailTrackerProviderCallout' AND JobType = 'Queueable' AND Status = 'Queued'];
        Assert.areEqual(badgeGenerator.records.size(), queuedJobs.size(), 'Expected one queued Trail Tracker Provider callout per Recommended Badge.');

        cleanup(queuedJobs, false);
        Test.stopTest();
    }

    @isTest
    private static void it_should_enqueue_jobs_and_publish_record_events() {
        // make Recommended Badge Mix private so record triggered flows on Recommended Badge and Mix Category don't invoke DML
        Recommended_Badge_Mix__c testBadgeMix = [SELECT Id FROM Recommended_Badge_Mix__c];
        testBadgeMix.Private_Mix__c = true;
        update testBadgeMix; 
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet())
            }
        );
        
        Test.startTest();
        RecommendedBadgeTrailTriggerHelper.enabledForTesting = true;
        insert badgeGenerator.generate();

        List<AsyncApexJob> queuedJobs = [SELECT Id FROM AsyncApexJob WHERE ApexClass.Name = 'QueueableTrailTrackerProviderCallout' AND JobType = 'Queueable' AND Status = 'Queued'];
        Integer numPublishedRecordEvents = Limits.getDmlRows() - badgeGenerator.records.size();

        Assert.areEqual(
            Limits.getLimitQueueableJobs(), 
            queuedJobs.size(), 
            'Expected the number of queued Trail Tracker Provider callouts to equal the Apex governor on queued jobs.'
        );
        Assert.areEqual(
            2,
            Limits.getDmlStatements(), 
            'Expected two DML statements - one to insert Recommended Badges and one to publish NewRecommendedBadgeTrailEvent__e platform events.'
        );
        Assert.areEqual(
            badgeGenerator.records.size() - Limits.getLimitQueueableJobs(), 
            numPublishedRecordEvents, 
            'Expected the number of published NewRecommendedBadgeTrailEvent__e events to equal the number of Recommended Badges minus the Apex governor limit on queued jobs.'
        );
        
        cleanup(queuedJobs, true);
        Test.stopTest();
    }

    @isTest
    private static void it_should_update_urls_for_new_badges() {
        Integer numberToGenerate = 50;
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false,
                'generatorReturnValue' => 'all',
                'numberToGenerate' => numberToGenerate
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet()),
                new TestSupport.TestDataField(Recommended_Badge__c.Type__c, 'Module'),
                new CounterSuffixField(Recommended_Badge__c.URL__c, RecommendedBadgeTrailTriggerHelper.TRAILHEAD_URL_MAPPINGS.get('Module').defaultPath + '/Test_Badge_')
            }
        );
        badgeGenerator.generate();
        badgeGenerator.setFieldSpec(new TestSupport.TestDataField(Recommended_Badge__c.URL__c, '')).generate();
        badgeGenerator.setFieldSpecs(new List<TestSupport.TestDataField>{
            new CounterSuffixField(Recommended_Badge__c.BadgeAPIName__c, 'Test_Project_'),
            new TestSupport.TestDataField(Recommended_Badge__c.Type__c, 'Project'),
            new CounterSuffixField(Recommended_Badge__c.URL__c, RecommendedBadgeTrailTriggerHelper.TRAILHEAD_URL_MAPPINGS.get('Project').defaultPath + '/Test_Project_')
        }).generate();
        List<Recommended_Badge__c> testBadges = (List<Recommended_Badge__c>) badgeGenerator.setFieldSpecs(new List<TestSupport.TestDataField>{
            new CounterSuffixField(Recommended_Badge__c.BadgeAPIName__c, 'Test_Superbadge_'),
            new TestSupport.TestDataField(Recommended_Badge__c.Type__c, 'Superbadge'),
            new CounterSuffixField(Recommended_Badge__c.URL__c, RecommendedBadgeTrailTriggerHelper.TRAILHEAD_URL_MAPPINGS.get('Superbadge').defaultPath + '/Test_Superbadge_')
        }).generate();

        Test.startTest();
        insert testBadges;
        Test.stopTest();

        testBadges = [SELECT Id, BadgeAPIName__c, Type__c, URL__c FROM Recommended_Badge__c];
        Integer numNullURLs = 0;
        for(Recommended_Badge__c badge : testBadges) {
            if(badge.URL__c == null) {
                numNullURLs++;
            } else {
                Assert.areEqual(
                    RecommendedBadgeTrailTriggerHelper.TRAILHEAD_URL_MAPPINGS.get(badge.Type__c).trailheadPath + '/' + badge.BadgeAPIName__c,
                    badge.URL__c,
                    'Expected URL to be updated to Trailhead path from default path.'
                );
            }
        }
        Assert.areEqual(numberToGenerate, numNullURLs, 'Expected null URL to be unchanged by RecommendedBadgeTrailTriggerHelper.updateURLPaths().');
    }

    @isTest
    private static void it_should_update_urls_for_updated_badges() {
        String testURL = 'www.test.com';
        List<Recommended_Badge__c> testBadges = (List<Recommended_Badge__c>) new RecommendedBadgeTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet()),
                new TestSupport.TestDataField(Recommended_Badge__c.URL__c, testURL)
            }
        ).generate();
        insert testBadges;

        Integer counter = 0;
        for(Recommended_Badge__c badge : testBadges) {
            if(counter < 150) {
                badge.URL__c = RecommendedBadgeTrailTriggerHelper.TRAILHEAD_URL_MAPPINGS.get(badge.Type__c).defaultPath + '/' + badge.BadgeAPIName__c;
                counter++;
            }
            badge.Description__c = 'Updated description.';
        }

        Test.startTest();
        update testBadges;
        Test.stopTest();

        testBadges = [SELECT Id, BadgeAPIName__c, Type__c, URL__c FROM Recommended_Badge__c];
        Integer numUnchangedURLs = 0;
        for(Recommended_Badge__c badge : testBadges) {
            if(badge.URL__c == testURL) {
                numUnchangedURLs++;
            } else {
                Assert.areEqual(
                    RecommendedBadgeTrailTriggerHelper.TRAILHEAD_URL_MAPPINGS.get(badge.Type__c).trailheadPath + '/' + badge.BadgeAPIName__c,
                    badge.URL__c,
                    'Expected URL to be updated to Trailhead path from default path.'
                );
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