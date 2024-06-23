@isTest(IsParallel=true)
private class TrailheadEntityService_Tests {
    private static final Set<String> MAPPED_BADGE_FIELDS = new Set<String>{
        'Archived__c',
        'BadgeName__c',
        'Description__c',
        'Icon__c',
        'Level__c',
        'Products__c',
        'Type__c',
        'URL__c'
    };

    private static final Set<String> MAPPED_TRAIL_FIELDS = new Set<String>{
        'Archived__c',
        'Description__c',
        'Icon__c',
        'Level__c',
        'Products__c',
        'TrailName__c',
        'URL__c'
    };

    @testSetup
    private static void generateMasterRecords() {
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 10});
        insert badgeMixGenerator.generate();
        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object>{'generateMasterRecords' => false, 'generateRecordIDs' => false, 'numberToGenerate' => 100},
            new List<TestSupport.TestDataField>{new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, sObject>(badgeMixGenerator.records)).keySet())}  
        );
        insert mixCategoryGenerator.generate();
    }

    private static RecommendedBadgeTS generateRecommendedBadges(Set<Id> mixCategoryIds) {
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object>{'generateMasterRecords' => false, 'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{new RelationshipField(Recommended_Badge__c.Mix_Category__c, mixCategoryIds)}    
        );
        insert badgeGenerator.generate();

        return badgeGenerator;
    }

    private static Map<String, Recommended_Badge__c> generateRecommendedBadgesByAPIName(RecommendedBadgeTS badgeGenerator) {
        badgeGenerator.clearField(Recommended_Badge__c.Id).
            clearField(Recommended_Badge__c.BadgeName__c).
            clearField(Recommended_Badge__c.Description__c).
            clearField(Recommended_Badge__c.Icon__c).
            clearField(Recommended_Badge__c.Type__c).
            clearField(Recommended_Badge__c.URL__c).
            changeField(Recommended_Badge__c.Level__c).
            changeField(Recommended_Badge__c.Products__c, 'New test products');
        
        Map<String, Recommended_Badge__c> badgesByAPIName = new Map<String, Recommended_Badge__c>();
        Recommended_Badge__c tempBadge;
        for(sObject badge : badgeGenerator.modifiedRecords) {
            tempBadge = new Recommended_Badge__c();
            for(String field : badge.getPopulatedFieldsAsMap().keySet()) {
                if(MAPPED_BADGE_FIELDS.contains(field) && (badge.get(field) != null)) {
                    tempBadge.put(field, badge.get(field));
                }
            }
            badgesByAPIName.put(String.valueOf(badge.get('BadgeAPIName__c')), tempBadge);
        }
        
        return badgesByAPIName;
    }

    private static RecommendedTrailTS generateRecommendedTrails(Set<Id> mixCategoryIds) {
        RecommendedTrailTS trailGenerator = new RecommendedTrailTS(
            new Map<String, Object>{'generateMasterRecords' => false, 'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{new RelationshipField(Recommended_Trail__c.Mix_Category__c, mixCategoryIds)}
        );
        insert trailGenerator.generate();
        
        return trailGenerator;
    }

    private static Map<String, Recommended_Trail__c> generateRecommendedTrailsByAPIName(RecommendedTrailTS trailGenerator) {
        trailGenerator.clearField(Recommended_Trail__c.Id).
            clearField(Recommended_Trail__c.TrailName__c).
            clearField(Recommended_Trail__c.Description__c).
            clearField(Recommended_Trail__c.Icon__c).
            clearField(Recommended_Trail__c.URL__c).
            changeField(Recommended_Trail__c.Level__c).
            changeField(Recommended_Trail__c.Products__c, 'New test products');
    
        Map<String, Recommended_Trail__c> trailsByAPIName = new Map<String, Recommended_Trail__c>();
        Recommended_Trail__c tempTrail;
        for(sObject trail : trailGenerator.modifiedRecords) {
            tempTrail = new Recommended_Trail__c();
            for(String field : trail.getPopulatedFieldsAsMap().keySet()) {
                if(MAPPED_TRAIL_FIELDS.contains(field) && (trail.get(field) != null)) {
                    tempTrail.put(field, trail.get(field));
                }
            }
            trailsByAPIName.put(String.valueOf(trail.get('TrailAPIName__c')), tempTrail);
        }

        return trailsByAPIName;
    }

    @isTest
    private static void it_should_update_badges_and_trails() {
        Set<Id> mixCategoryIds = (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet();
        Map<String, Recommended_Badge__c> badgesByAPIName = generateRecommendedBadgesByAPIName(generateRecommendedBadges(mixCategoryIds));
        Map<String, Recommended_Trail__c> trailsByAPIName = generateRecommendedTrailsByAPIName(generateRecommendedTrails(mixCategoryIds));

        Test.startTest();
        TrailheadEntityService.doPatch(badgesByAPIName, trailsByAPIName);
        Test.stopTest();

        List<Recommended_Badge__c> updatedBadges = [SELECT BadgeAPIName__c, Level__c, Products__c FROM Recommended_Badge__c];
        List<Recommended_Trail__c> updatedTrails = [SELECT TrailAPIName__c, Level__c, Products__c FROM Recommended_Trail__c];
        List<LogEntry__c> logEntries = [SELECT Id FROM LogEntry__c];
        for(Recommended_Badge__c badge : updatedBadges) {
            Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Level__c, badge.Level__c, 'Expected Recommended Badge level to be updated by PATCH call.');
            Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Products__c, badge.Products__c, 'Expected Recommended Badge products field to be updated by PATCH call.');
        }
        for(Recommended_Trail__c trail : updatedTrails) {
            Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Level__c, trail.Level__c, 'Expected Recommended Trail level to be updated by PATCH call.');
            Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Products__c, trail.Products__c, 'Expected Recommended Trail products field to be updated by PATCH call.');
        }
        Assert.areEqual(0, logEntries.size(), 'Expected PATCH call to execute successfully.');
    }

    @isTest
    private static void it_should_update_badges_and_trails_with_same_name_in_different_mixes() {
        List<Recommended_Badge_Mix__c> badgeMixes = [SELECT Id, (SELECT Id FROM Mix_Categories__r) FROM Recommended_Badge_Mix__c];
        RecommendedBadgeTS badgeGenerator = generateRecommendedBadges((new Map<Id, Mix_Category__c>(badgeMixes[0].Mix_Categories__r)).keySet());
        insert badgeGenerator.setFieldSpecs(new List<TestSupport.TestDataField>{
                new CounterSuffixField(Recommended_Badge__c.BadgeAPIName__c, 'Test_Badge_'),
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, Mix_Category__c>(badgeMixes[1].Mix_Categories__r).keySet()))
            }).
            generate();

        RecommendedTrailTS trailGenerator = generateRecommendedTrails((new Map<Id, Mix_Category__c>(badgeMixes[0].Mix_Categories__r)).keySet());
        insert trailGenerator.setFieldSpecs(new List<TestSupport.TestDataField>{
                new CounterSuffixField(Recommended_Trail__c.TrailAPIName__c, 'Test_Trail_'),
                new RelationshipField(Recommended_Trail__c.Mix_Category__c, (new Map<Id, Mix_Category__c>(badgeMixes[1].Mix_Categories__r).keySet()))
            }).
            generate();
        
        Map<String, Recommended_Badge__c> badgesByAPIName = generateRecommendedBadgesByAPIName(badgeGenerator);
        Map<String, Recommended_Trail__c> trailsByAPIName = generateRecommendedTrailsByAPIName(trailGenerator);
        Test.startTest();
        TrailheadEntityService.doPatch(badgesByAPIName, trailsByAPIName);
        Test.stopTest();

        List<Recommended_Badge__c> updatedBadges = [SELECT BadgeAPIName__c, Level__c, Products__c FROM Recommended_Badge__c];
        for(Recommended_Badge__c badge : updatedBadges) {
            Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Level__c, badge.Level__c, 'Expected Recommended Badge level to be updated by PATCH call.');
            Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Products__c, badge.Products__c, 'Expected Recommended Badge products field to be updated by PATCH call.');
        }

        List<Recommended_Trail__c> updatedTrails = [SELECT TrailAPIName__c, Level__c, Products__c FROM Recommended_Trail__c];
        for(Recommended_Trail__c trail : updatedTrails) {
            Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Level__c, trail.Level__c, 'Expected Recommended Trail level to be updated by PATCH call.');
            Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Products__c, trail.Products__c, 'Expected Recommended Trail products field to be updated by PATCH call.');
        }

        List<LogEntry__c> logEntries = [SELECT Id FROM LogEntry__c];
        Assert.areEqual(0, logEntries.size(), 'Expected PATCH call to execute successfully.');
    }

    @isTest
    private static void it_should_throw_exception_when_badge_updates_fail() {
        Set<Id> mixCategoryIds = (new Map<Id, sObject>([SELECT id FROM Mix_Category__c])).keySet();
        Map<String, Recommended_Badge__c> badgesByAPIName = generateRecommendedBadgesByAPIName(generateRecommendedBadges(mixCategoryIds));
        badgesByAPIName.values()[0].Level__c = 'Bad Level';

        Test.startTest();
        try {
            TrailheadEntityService.doPatch(badgesByAPIName, new Map<String, Recommended_Trail__c>());
            Assert.fail('Expected exception when or more Recommended Badges fails update.');
        } catch(Exception e) {
            Assert.areEqual('TrailheadEntityService.TrailheadEntityServiceException', e.getTypeName(), 'Expected exception when one or more Recommended Badges fails update.');
            Assert.areEqual(TrailheadEntityService.DML_UPDATE_ERROR_MESSAGE, e.getMessage(), 'Expected exception when one or more Recommended Badges fails update.');
        }
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [
            SELECT Id, RecordId__c 
            FROM LogEntry__c 
            WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR' AND RecordId__c != null
        ];
        Assert.areEqual(1, loggedErrors.size(), 'Expected logged error for Recommended Badge that failed update.');

        List<Recommended_Badge__c> updatedBadges = [SELECT BadgeAPIName__c, Level__c, Products__c FROM Recommended_Badge__c];
        for(Recommended_Badge__c badge : updatedBadges) {
            if(badge.Id == loggedErrors[0].RecordId__c) {
                Assert.areNotEqual(
                    badgesByAPIName.get(badge.BadgeAPIName__c).Level__c, 
                    badge.Level__c, 
                    'Expected Recommended Badge level to be unchanged by PATCH call when DML fails.'
                );
                Assert.areNotEqual(
                    badgesByAPIName.get(badge.BadgeAPIName__c).Products__c, 
                    badge.Products__c, 
                    'Expected Recommended Badge products field to be unchanged by PATCH call when DML fails.'
                );
            } else {
                Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Level__c, badge.Level__c, 'Expected Recommended Badge level to be updated by PATCH call.');
                Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Products__c, badge.Products__c, 'Expected Recommended Badge products field to be updated by PATCH call.');
            }
        }
    }

    @isTest
    private static void it_should_throw_exception_when_trail_updates_fail() {
        Set<Id> mixCategoryIds = (new Map<Id, sObject>([SELECT id FROM Mix_Category__c])).keySet();
        Map<String, Recommended_Trail__c> trailsByAPIName = generateRecommendedTrailsByAPIName(generateRecommendedTrails(mixCategoryIds));
        trailsByAPIName.values()[0].Level__c = 'Bad Level';

        Test.startTest();
        try {
            TrailheadEntityService.doPatch(new Map<String, Recommended_Badge__c>(), trailsByAPIName);
            Assert.fail('Expected exception when or more Recommended Trails fails update.');
        } catch(Exception e) {
            Assert.areEqual('TrailheadEntityService.TrailheadEntityServiceException', e.getTypeName(), 'Expected exception when one or more Recommended Trails fails update.');
            Assert.areEqual(TrailheadEntityService.DML_UPDATE_ERROR_MESSAGE, e.getMessage(), 'Expected exception when one or more Recommended Trails fails update.');
        }
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [
            SELECT Id, RecordId__c 
            FROM LogEntry__c 
            WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR' AND RecordId__c != null
        ];
        Assert.areEqual(1, loggedErrors.size(), 'Expected logged error for Recommended Trail that failed update.');

        List<Recommended_Trail__c> updatedTrails = [SELECT TrailAPIName__c, Level__c, Products__c FROM Recommended_Trail__c];
        for(Recommended_Trail__c trail : updatedTrails) {
            if(trail.Id == loggedErrors[0].RecordId__c) {
                Assert.areNotEqual(
                    trailsByAPIName.get(trail.TrailAPIName__c).Level__c, 
                    trail.Level__c, 
                    'Expected Recommended Trail level to be unchanged by PATCH call when DML fails.'
                );
                Assert.areNotEqual(
                    trailsByAPIName.get(trail.TrailAPIName__c).Products__c, 
                    trail.Products__c, 
                    'Expected Recommended Trail products field to be unchanged by PATCH call when DML fails.'
                );
            } else {
                Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Level__c, trail.Level__c, 'Expected Recommended Trail level to be updated by PATCH call.');
                Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Products__c, trail.Products__c, 'Expected Recommended Trail products field to be updated by PATCH call.');
            }
        }
    }

    @isTest
    private static void it_should_throw_exception_when_badge_and_trail_updates_fail() {
        Set<Id> mixCategoryIds = (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet();
        Map<String, Recommended_Badge__c> badgesByAPIName = generateRecommendedBadgesByAPIName(generateRecommendedBadges(mixCategoryIds));
        Map<String, Recommended_Trail__c> trailsByAPIName = generateRecommendedTrailsByAPIName(generateRecommendedTrails(mixCategoryIds));
        badgesByAPIName.values()[0].Level__c = 'Bad Level';
        trailsByAPIName.values()[0].Level__c = 'Bad Level';

        Test.startTest();
        try {
            TrailheadEntityService.doPatch(badgesByAPIName, trailsByAPIName);
            Assert.fail('Expected exception when or more Recommended Badges fails update.');
        } catch(Exception e) {
            Assert.areEqual('TrailheadEntityService.TrailheadEntityServiceException', e.getTypeName(), 'Expected exception when one or more Recommended Badges fails update.');
            Assert.areEqual(TrailheadEntityService.DML_UPDATE_ERROR_MESSAGE, e.getMessage(), 'Expected exception when one or more Recommended Badges fails update.');
        }
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [
            SELECT Id, RecordId__c 
            FROM LogEntry__c 
            WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR' AND RecordId__c != null
        ];
        Assert.areEqual(2, loggedErrors.size(), 'Expected logged errors for records that failed update.');

        Boolean failedUpdate = false;
        List<Recommended_Badge__c> updatedBadges = [SELECT BadgeAPIName__c, Level__c, Products__c FROM Recommended_Badge__c];
        for(Recommended_Badge__c badge : updatedBadges) {
            for(LogEntry__c error : loggedErrors) {
                if(badge.Id == error.RecordId__c) {
                    Assert.areNotEqual(
                        badgesByAPIName.get(badge.BadgeAPIName__c).Level__c, 
                        badge.Level__c, 
                        'Expected Recommended Badge level to be unchanged by PATCH call when DML fails.'
                    );
                    Assert.areNotEqual(
                        badgesByAPIName.get(badge.BadgeAPIName__c).Products__c, 
                        badge.Products__c, 
                        'Expected Recommended Badge products field to be unchanged by PATCH call when DML fails.'
                    );
                    failedUpdate = true;
                    break;
                }
            }

            if(!failedUpdate) {
                Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Level__c, badge.Level__c, 'Expected Recommended Badge level to be updated by PATCH call.');
                Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Products__c, badge.Products__c, 'Expected Recommended Badge products field to be updated by PATCH call.');
            }
            failedUpdate = false;
        } 
        
        List<Recommended_Trail__c> updatedTrails = [SELECT TrailAPIName__c, Level__c, Products__c FROM Recommended_Trail__c];
        for(Recommended_Trail__c trail : updatedTrails) {
            for(LogEntry__c error : loggedErrors) {
                if(trail.Id == loggedErrors[0].RecordId__c) {
                    Assert.areNotEqual(
                        trailsByAPIName.get(trail.TrailAPIName__c).Level__c, 
                        trail.Level__c, 
                        'Expected Recommended Trail level to be unchanged by PATCH call when DML fails.'
                    );
                    Assert.areNotEqual(
                        trailsByAPIName.get(trail.TrailAPIName__c).Products__c, 
                        trail.Products__c, 
                        'Expected Recommended Trail products field to be unchanged by PATCH call when DML fails.'
                    );
                }
                failedUpdate = true;
                break;
            }

            if(!failedUpdate) {
                Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Level__c, trail.Level__c, 'Expected Recommended Trail level to be updated by PATCH call.');
                Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Products__c, trail.Products__c, 'Expected Recommended Trail products field to be updated by PATCH call.');
            }
            failedUpdate = false;
        }
    }

    @isTest
    private static void it_should_delete_badges_and_trails() {
        Set<Id> mixCategoryIds = (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet();
        Set<String> badgeAPINames = generateRecommendedBadgesByAPIName(generateRecommendedBadges(mixCategoryIds)).keySet();
        Set<String> trailAPINames = generateRecommendedTrailsByAPIName(generateRecommendedTrails(mixCategoryIds)).keySet();
        RestRequest request = new RestRequest();
        request.requestURI = '/TrailheadEntities';
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"deletedBadgeAPINames": ' + JSON.serialize(badgeAPINames) + ', "deletedTrailAPINames": ' + JSON.serialize(trailAPINames) + '}');
        RestContext.request = request;

        Test.startTest();
        TrailheadEntityService.doDelete();
        Test.stopTest();

        List<Recommended_Badge__c> badges = [SELECT Id FROM Recommended_Badge__c];
        List<Recommended_Trail__c> trails = [SELECT Id FROM Recommended_Trail__c];
        List<LogEntry__c> logEntries = [SELECT Id FROM LogEntry__c];
        Assert.areEqual(0, badges.size(), 'Expected Recommended Badges to be deleted by DELETE call.');
        Assert.areEqual(0, trails.size(), 'Expected Recommended Trails to be deleted by DELETE call.');
        Assert.areEqual(0, logEntries.size(), 'Expected DELETE call to execute successfully.');
    }

    @isTest
    private static void it_should_delete_badges_and_trails_with_same_name_in_different_mixes() {
        List<Recommended_Badge_Mix__c> badgeMixes = [SELECT Id, (SELECT Id FROM Mix_Categories__r) FROM Recommended_Badge_Mix__c];
        RecommendedBadgeTS badgeGenerator = generateRecommendedBadges((new Map<Id, Mix_Category__c>(badgeMixes[0].Mix_Categories__r)).keySet());
        insert badgeGenerator.setFieldSpecs(new List<TestSupport.TestDataField>{
                new CounterSuffixField(Recommended_Badge__c.BadgeAPIName__c, 'Test_Badge_'),
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, Mix_Category__c>(badgeMixes[1].Mix_Categories__r).keySet()))
            }).
            generate();

        RecommendedTrailTS trailGenerator = generateRecommendedTrails((new Map<Id, Mix_Category__c>(badgeMixes[0].Mix_Categories__r)).keySet());
        insert trailGenerator.setFieldSpecs(new List<TestSupport.TestDataField>{
                new CounterSuffixField(Recommended_Trail__c.TrailAPIName__c, 'Test_Trail_'),
                new RelationshipField(Recommended_Trail__c.Mix_Category__c, (new Map<Id, Mix_Category__c>(badgeMixes[1].Mix_Categories__r).keySet()))
            }).
            generate();
        
        Set<String> badgeAPINames = generateRecommendedBadgesByAPIName(badgeGenerator).keySet();
        Set<String> trailAPINames = generateRecommendedTrailsByAPIName(trailGenerator).keySet();
        RestRequest request = new RestRequest();
        request.requestURI = '/TrailheadEntities';
        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"deletedBadgeAPINames": ' + JSON.serialize(badgeAPINames) + ', "deletedTrailAPINames": ' + JSON.serialize(trailAPINames) + '}');
        RestContext.request = request;

        Test.startTest();
        TrailheadEntityService.doDelete();
        Test.stopTest();

        List<Recommended_Badge__c> badges = [SELECT Id FROM Recommended_Badge__c];
        List<Recommended_Trail__c> trails = [SELECT Id FROM Recommended_Trail__c];
        List<LogEntry__c> logEntries = [SELECT Id FROM LogEntry__c];
        Assert.areEqual(0, badges.size(), 'Expected Recommended Badges to be deleted by DELETE call.');
        Assert.areEqual(0, trails.size(), 'Expected Recommended Trails to be deleted by DELETE call.');
        Assert.areEqual(0, logEntries.size(), 'Expected DELETE call to execute successfully.');
    }
}