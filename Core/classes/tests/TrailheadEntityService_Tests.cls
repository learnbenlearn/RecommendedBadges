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

    private static Map<String, Recommended_Badge__c> generateRecommendedBadgesByAPIName(Set<Id> mixCategoryIds) {
        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object>{'generateMasterRecords' => false, 'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{new RelationshipField(Recommended_Badge__c.Mix_Category__c, mixCategoryIds)}    
        );
        insert badgeGenerator.generate();

        badgeGenerator.clearField(Recommended_Badge__c.BadgeName__c).
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

    private static Map<String, Recommended_Trail__c> generateRecommendedTrailsByAPIName(Set<Id> mixCategoryIds) {
        RecommendedTrailTS trailGenerator = new RecommendedTrailTS(
            new Map<String, Object>{'generateMasterRecords' => false, 'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{new RelationshipField(Recommended_Trail__c.Mix_Category__c, mixCategoryIds)}
        );
        insert trailGenerator.generate();


        trailGenerator.clearField(Recommended_Trail__c.TrailName__c).
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
        Map<String, Recommended_Badge__c> badgesByAPIName = generateRecommendedBadgesByAPIName(mixCategoryIds);
        Map<String, Recommended_Trail__c> trailsByAPIName = generateRecommendedTrailsByAPIName(mixCategoryIds);

        Test.startTest();
        TrailheadEntityService.doPatch(badgesByAPIName, trailsByAPIName);
        Test.stopTest();

        List<Recommended_Badge__c> updatedBadges = [SELECT BadgeAPIName__c, Level__c, Products__c FROM Recommended_Badge__c];
        List<Recommended_Trail__c> updatedTrails = [SELECT TrailAPIName__c, Level__c, Products__c FROM Recommended_Trail__c];
        for(Recommended_Badge__c badge : updatedBadges) {
            Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Level__c, badge.Level__c, 'Expected Recommended Badge level to be updated by PATCH call.');
            Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Products__c, badge.Products__c, 'Expected Recommended Badge products field to be updated by PATCH call.');
        }
        for(Recommended_Trail__c trail : updatedTrails) {
            Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Level__c, trail.Level__c, 'Expected Recommended Trail level to be updated by PATCH call.');
            Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Products__c, trail.Products__c, 'Expected Recommended Trail products field to be updated by PATCH call.');
        }
    }

    @isTest
    private static void it_should_update_badges_with_same_name_in_different_mixes() {
        

    }

    @isTest
    private static void it_should_update_badges_when_no_trail_updates() {
        Set<Id> mixCategoryIds = (new Map<Id, sObject>([SELECT Id FROM Mix_Category__c])).keySet();
        Map<String, Recommended_Badge__c> badgesByAPIName = generateRecommendedBadgesByAPIName(mixCategoryIds);

        Test.startTest();
        TrailheadEntityService.doPatch(badgesByAPIName, new Map<String, Recommended_Trail__c>());
        Test.stopTest();

        List<Recommended_Badge__c> updatedBadges = [SELECT BadgeAPIName__c, Level__c, Products__c FROM Recommended_Badge__c];
        for(Recommended_Badge__c badge : updatedBadges) {
            Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Level__c, badge.Level__c, 'Expected Recommended Badge level to be updated by PATCH call.');
            Assert.areEqual(badgesByAPIName.get(badge.BadgeAPIName__c).Products__c, badge.Products__c, 'Expected Recommended Badge products field to be updated by PATCH call.');
        }
    }

    @isTest
    private static void it_should_update_trails_when_no_badge_updates() {
        Set<Id> mixCategoryIds = (new Map<Id, sObject>([SELECT id FROM Mix_Category__c])).keySet();
        Map<String, Recommended_Trail__c> trailsByAPIName = generateRecommendedTrailsByAPIName(mixCategoryIds);

        Test.startTest();
        TrailheadEntityService.doPatch(new Map<String, Recommended_Badge__c>(), trailsByAPIName);
        Test.stopTest();

        List<Recommended_Trail__c> updatedTrails = [SELECT TrailAPIName__c, Level__c, Products__c FROM Recommended_Trail__c];
        for(Recommended_Trail__c trail : updatedTrails) {
            Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Level__c, trail.Level__c, 'Expected Recommended Trail level to be updated by PATCH call.');
            Assert.areEqual(trailsByAPIName.get(trail.TrailAPIName__c).Products__c, trail.Products__c, 'Expected Recommended Trail products field to be updated by PATCH call.');
        }
    }

    @isTest
    private static void it_should_throw_exception_when_badge_updates_fail() {
        Set<Id> mixCategoryIds = (new Map<Id, sObject>([SELECT id FROM Mix_Category__c])).keySet();
        Map<String, Recommended_Badge__c> badgesByAPIName = generateRecommendedBadgesByAPIName(mixCategoryIds);
        //badgesByAPIName.values()[0]
        //new Map<String, Recommended_Badge__c>
    }

    @isTest
    private static void it_should_throw_exception_when_trail_updates_fail() {

    }

    @isTest
    private static void it_should_throw_exception_when_badge_and_trail_updates_fail() {
        
    }
}