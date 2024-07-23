@isTest
private class RecommendedBadgeTrigger_Tests {
    @testSetup
    private static void generateData(){
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 2});
        insert badgeMixGenerator.generate();

        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object>{'generateRecordIDs' => false, 'generateMasterRecords' => false, 'numberToGenerate' => 4},
            new List<TestSupport.TestDataField>{new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, sObject>(badgeMixGenerator.records)).keySet())}
        );
        insert mixCategoryGenerator.generate();
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
            RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
                new Map<String, Object>{'generateRecordIDs' => false}, 
                new List<TestSupport.TestDataField>{
                    new BooleanField(Recommended_Badge__c.High_Priority__c, true),
                    new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, Mix_Category__c>{testMixCategories[0].Id => testMixCategories[0]}).keySet())}
            );
            insert badgeGenerator.generate();
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

        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object>{'generateRecordIDs' => false}, 
            new List<TestSupport.TestDataField>{
                new BooleanField(Recommended_Badge__c.High_Priority__c, true),
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, Mix_Category__c>{testMixCategories[0].Id => testMixCategories[0]}).keySet())}
        );
        List<Recommended_Badge__c> badges = (List<Recommended_Badge__c>) badgeGenerator.generate();
        badges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[0].Id,
            BadgeAPIName__c='Test_Badge_' + Integer.valueOf(Math.floor(Math.random() * badges.size()))
        ));

        try {
            Test.startTest();
            insert badges;
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
        
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object>{'generateRecordIDs' => false}, 
            new List<TestSupport.TestDataField>{
                new BooleanField(Recommended_Badge__c.High_Priority__c, true),
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, Mix_Category__c>{testMixCategories[0].Id => testMixCategories[0]}).keySet())}
        );
        List<Recommended_Badge__c> badges = (List<Recommended_Badge__c>) badgeGenerator.generate();

        try {
            Test.startTest();
            insert badges;

            for(Integer i = 0; i < 200; i++) {
                badges[i].Mix_Category__c = testMixCategories[1].Id;
            }

            update badges;
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


        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object>{'generateRecordIDs' => false, 'generatorReturnValue' => 'all'}, 
            new List<TestSupport.TestDataField>{
                new BooleanField(Recommended_Badge__c.High_Priority__c, true),
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, Mix_Category__c>{testMixCategories[0].Id => testMixCategories[0]}).keySet())}
        );
        badgeGenerator.generate();
        List<Recommended_Badge__c> badges = (List<Recommended_Badge__c>) badgeGenerator.setFieldSpecs(new List<TestSupport.TestDataField>{
            new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, Mix_Category__c>{testMixCategories[1].Id => testMixCategories[1]}.keySet())),
            new CounterSuffixField(Recommended_Badge__c.BadgeAPIName__c, 'Test_Badge_')
        }).generate();

        try {
            Test.startTest();
            insert badges;
            
            for(Recommended_Badge__c rb : badges) {
                if(rb.Mix_Category__c == testMixCategories[0].Id) {
                    rb.Mix_Category__c = testMixCategories[1].Id;
                }
            }
            update badges;
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
        // use private Recommended Badge Mix so record triggered flows on Recommended Badge and Mix Category don't invoke DML
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(
                    Recommended_Badge__c.Mix_Category__c, 
                    (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c WHERE Recommended_Badge_Mix__r.Private_Mix__c = true])).keySet()
                )
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

    @isTest
    private static void it_should_clear_time_estimates_and_high_priority_on_change_to_public_mix() {
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(
                    Recommended_Badge__c.Mix_Category__c, 
                    (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c WHERE Recommended_Badge_Mix__r.Private_Mix__c = true])).keySet()
                ),
                new TestSupport.TestDataField(Recommended_Badge__c.High_Priority__c, true),
                new RandomIntegerField(Recommended_Badge__c.Hours_Estimate__c, 0, 60),
                new RandomIntegerField(Recommended_Badge__c.Minutes_Estimate__c, 0, 60)
            }
        );
        insert badgeGenerator.generate();

        badgeGenerator.changeField(
            Recommended_Badge__c.Mix_Category__c, 
            [SELECT Id FROM Mix_Category__c WHERE Recommended_Badge_Mix__r.Private_Mix__c = false LIMIT 1].Id
        );

        Test.startTest();
        update badgeGenerator.modifiedRecords;
        Test.stopTest();

        List<Recommended_Badge__c> badges = [SELECT Id FROM Recommended_Badge__c WHERE High_Priority__c = false AND Hours_Estimate__c = null AND Minutes_Estimate__c = null];
        Assert.areEqual(
            badgeGenerator.modifiedRecords.size(), 
            badges.size(), 
            'Expected High Priority, Hours Estimate, and Minutes Estimate fields to be reset when Recommended Badge is moved to a public mix.'
        );
    }

    @isTest
    private static void it_should_leave_time_estimates_and_high_priority_on_change_to_private_mix() {
        List<Id> privateMixCategories = new List<Id>(
            (new Map<Id, Mix_Category__c>([SELECT Id FROM Mix_Category__c WHERE Recommended_Badge_Mix__r.Private_Mix__c = true])).keySet()
        );
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object> {
                'generateMasterRecords' => false,
                'generateRecordIDs' => false
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, new Set<Id>{privateMixCategories[0]}),
                new TestSupport.TestDataField(Recommended_Badge__c.High_Priority__c, true),
                new RandomIntegerField(Recommended_Badge__c.Hours_Estimate__c, 0, 60),
                new RandomIntegerField(Recommended_Badge__c.Minutes_Estimate__c, 0, 60)
            }
        );
        insert badgeGenerator.generate();

        badgeGenerator.changeField(Recommended_Badge__c.Mix_Category__c, privateMixCategories[1]);

        Test.startTest();
        update badgeGenerator.modifiedRecords;
        Test.stopTest();

        List<Recommended_Badge__c> badges = [
            SELECT Id, Hours_Estimate__c, Minutes_Estimate__c 
            FROM Recommended_Badge__c 
            WHERE High_Priority__c = true AND Hours_Estimate__c != null AND Minutes_Estimate__c != null
        ];
        Assert.areEqual(
            badgeGenerator.modifiedRecords.size(), 
            badges.size(), 
            'Expected High Priority field to be unchanged when Recommended Badge is moved elsewhere within the same private mix or to a different private mix.'
        );

        Map<Id, Recommended_Badge__c> modifiedRecordsMap = new Map<Id, Recommended_Badge__c>((List<Recommended_Badge__c>) badgeGenerator.modifiedRecords);
        for(Recommended_Badge__c badge : badges) {
            Assert.areEqual(
                modifiedRecordsMap.get(badge.Id).Hours_Estimate__c, 
                badge.Hours_Estimate__c, 
                'Expected Hours Estimate field to be unchanged when Recommended Badge is moved elsewhere within the same private mix or to a different private mix.'
            );
            Assert.areEqual(
                modifiedRecordsMap.get(badge.Id).Minutes_Estimate__c,
                badge.Minutes_Estimate__c,
                'Expected Minutes Estimate field to be unchanged when Recommended Badge is moved elsewhere within the same private mix or to a different private mix.'
            );
        }
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