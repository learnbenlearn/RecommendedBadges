/**
 * @description       : Test class for BadgeTrigger_Helper class.
 * @author            : Ben Learn
 * @last modified on  : 01-13-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class BadgeTrigger_HelperTests {
    private static List<String> levels = new List<String>{
        'Beginner',
        'Intermediate',
        'Advanced'
    };

    private static List<String> types = new List<String>{
        'Module',
        'Project',
        'Superbadge'
    };

    @testSetup
    private static void generateData(){
        List<trailheadapp__Badge__c> testBadges = new List<trailheadapp__Badge__c>();
        List<trailheadapp__Trail__c> testTrails = new List<trailheadapp__Trail__c>();

        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = new List<Recommended_Badge_Mix__c>{
            new Recommended_Badge_Mix__c(Name='Test')
        };
        insert testRecommendedBadgeMixes;

        List<Mix_Category__c> testMixCategories = new List<Mix_Category__c>{
            new Mix_Category__c(
                Name='Test',
                Recommended_Badge_Mix__c=testRecommendedBadgeMixes[0].Id
            )
        };
        insert testMixCategories;

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        List<Recommended_Trail__c> testRecommendedTrails = new List<Recommended_Trail__c>();

        for(Integer i = 0; i < 200; i++) {
            trailheadapp__Badge__c badge = new trailheadapp__Badge__c(
                Name='Test Badge ' + i,
                trailheadapp__Level__c=levels[Integer.valueOf(Math.floor(Math.random()*levels.size()))],
                trailheadapp__Type__c=types[Integer.valueOf(Math.floor(Math.random()*types.size()))],
                trailheadapp__API_Name__c='Test_Badge_' + i,
                trailheadapp__Description__c='Test Description ' + i,
                trailheadapp__Namespace__c='Test Namespace ' + i,
                trailheadapp__URL__c='www.test' + i + '.com',
                trailheadapp__Icon__c='www.testicon' + i + '.com'
            );
            testBadges.add(badge);

            trailheadapp__Trail__c trail = new trailheadapp__Trail__c(
                Name='Test Trail ' + i,
                trailheadapp__Level__c=levels[Integer.valueOf(Math.floor(Math.random()*levels.size()))],
                trailheadapp__API_Name__c='Test_Trail_' + i,
                trailheadapp__Description__c='Test Description ' + i,
                trailheadapp__Namespace__c='Test Namespace ' + i,
                trailheadapp__URL__c='www.test' + i + '.com',
                trailheadapp__Icon__c='www.testicon' + i + '.com'
            );
            testTrails.add(trail);
        }

        insert testBadges;
        insert testTrails;
    }

    @isTest
    private static void testPopulateJunctionPicklists_singleBadge() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__Level__c, trailheadapp__Type__c FROM trailheadapp__Badge__c];

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random()*testBadges.size()));

        Test.startTest();
        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
            new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=testBadges[testBadgeIndex].Id
            )
        };
        insert testRecommendedBadges;
        Test.stopTest();

        List<Recommended_Badge__c> resultRecommendedBadges = [SELECT Level__c, Type__c FROM Recommended_Badge__c];
        System.assertEquals(
            testBadges[testBadgeIndex].trailheadapp__Level__c, 
            resultRecommendedBadges[0].Level__c,
            'Expected Recommended Badge level to be the same as parent Badge level.'
        );
        System.assertEquals(
            testBadges[testBadgeIndex].trailheadapp__Type__c, 
            resultRecommendedBadges[0].Type__c,
            'Expected Recommended Badge type to be the same as parent Badge type.'
        );
    }

    @isTest
    private static void testPopulateJunctionPicklists_bulkBadges() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        Map<Id, trailheadapp__Badge__c> testBadgeMap = new Map<Id, trailheadapp__Badge__c>(
            [SELECT Id, trailheadapp__Level__c, trailheadapp__Type__c FROM trailheadapp__Badge__c]
        );

        Test.startTest();
        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        for(Integer i = 0; i < 200; i++) {
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=testBadgeMap.values()[i].Id
            ));
        }
        insert testRecommendedBadges;
        Test.stopTest();

        List<Recommended_Badge__c> resultRecommendedBadges = [SELECT Badge__c, Level__c, Type__c FROM Recommended_Badge__c];
        for(Recommended_Badge__c rb : resultRecommendedBadges) {
            System.assertEquals(
                testBadgeMap.get(rb.Badge__c).trailheadapp__Level__c,
                rb.Level__c,
                'Expected Recommended Badge level to be the same as parent Badge level.'
            );
            System.assertEquals(
                testBadgeMap.get(rb.Badge__c).trailheadapp__Type__c,
                rb.Type__c,
                'Expected Recommended Badge type to be the same as parent Badge type.'
            );
        }
    }

    @isTest
    private static void testPopulateJunctionPicklists_singleBadgeNegative() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Badge__c> testNegativeBadge = new List<trailheadapp__Badge__c>{   
            new trailheadapp__Badge__c(
                Name='Test Badge ',
                trailheadapp__Level__c='',
                trailheadapp__Type__c='',
                trailheadapp__API_Name__c='Test_Badge',
                trailheadapp__Description__c='Test Description ',
                trailheadapp__Namespace__c='Test Namespace ',
                trailheadapp__URL__c='www.test.com',
                trailheadapp__Icon__c='www.testicon.com'
            )
        };
        insert testNegativeBadge;

        Test.startTest();
        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        testRecommendedBadges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[0].Id,
            Badge__c=testNegativeBadge[0].Id
        ));
        insert testRecommendedBadges;
        Test.stopTest();

        List<Recommended_Badge__c> resultRecommendedBadges = [SELECT Level__c, Type__c FROM Recommended_Badge__c];
        System.assertEquals(null, resultRecommendedBadges[0].Level__c, 'Expected Recommended Badge level to be null when parent Badge level is unpopulated.');
        System.assertEquals(null, resultRecommendedBadges[0].Type__c, 'Expected Recommended Badge type to be null when parent Badge type is unpopulated.');
    }

    @isTest
    private static void testPopulateJunctionPicklists_bulkBadgesNegative() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Badge__c> testNegativeBadge = new List<trailheadapp__Badge__c>{
            new trailheadapp__Badge__c(
                Name='Test Badge ',
                trailheadapp__Level__c='',
                trailheadapp__Type__c='',
                trailheadapp__API_Name__c='Test_Badge',
                trailheadapp__Description__c='Test Description ',
                trailheadapp__Namespace__c='Test Namespace ',
                trailheadapp__URL__c='www.test' + '.com',
                trailheadapp__Icon__c='www.testicon' + '.com'
            )
        };
        insert testNegativeBadge;

        Map<Id, trailheadapp__Badge__c> testBadgeMap = new Map<Id, trailheadapp__Badge__c>(
            [SELECT Id, trailheadapp__Level__c, trailheadapp__Type__c FROM trailheadapp__Badge__c]
        );

        Test.startTest();
        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        for(trailheadapp__Badge__c badge : testBadgeMap.values()) {
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=badge.Id
            ));
        }
        insert testRecommendedBadges;
        Test.stopTest();

        List<Recommended_Badge__c> resultRecommendedBadges = [SELECT Badge__c, Type__c, Level__c FROM Recommended_Badge__c];

        for(Recommended_Badge__c rb : resultRecommendedBadges) {
            System.assertEquals(
                testBadgeMap.get(rb.Badge__c).trailheadapp__Level__c,
                rb.Level__c,
                'Expected Recommended Badge level to be the same as parent Badge level.'
            );
            System.assertEquals(
                testBadgeMap.get(rb.Badge__c).trailheadapp__Type__c,
                rb.Type__c,
                'Expected Recommended Badge type to be the same as parent Badge type.'   
            );
        }
    }

    @isTest
    private static void testPopulateJunctionPicklists_singleTrail() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Trail__c> testTrails = [SELECT Id, trailheadapp__Level__c FROM trailheadapp__Trail__c];

        Integer testTrailIndex = Integer.valueOf(Math.floor(Math.random()*testTrails.size()));

        Test.startTest();
        List<Recommended_Trail__c> testRecommendedTrails = new List<Recommended_Trail__c>{     
            new Recommended_Trail__c(
                Mix_Category__c=testMixCategories[0].Id,
                Trail__c=testTrails[testTrailIndex].Id
            )
        };
        insert testRecommendedTrails;
        Test.stopTest();

        List<Recommended_Trail__c> resultRecommendedTrails = [SELECT Level__c FROM Recommended_Trail__c];
        System.assertEquals(
            testTrails[testTrailIndex].trailheadapp__Level__c, 
            resultRecommendedTrails[0].Level__c,
            'Expected Recommended Trail level to be the same as parent Trail level.'
        );
    }

    @isTest 
    private static void testPopulateJunctionPicklists_bulkTrails() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        Map<Id, trailheadapp__Trail__c> testTrailMap = new Map<Id, trailheadapp__Trail__c>([SELECT Id, trailheadapp__Level__c FROM trailheadapp__Trail__c]);

        List<Recommended_Trail__c> testRecommendedTrails = new List<Recommended_Trail__c>();

        Test.startTest();
        for(Integer i = 0; i < 200; i++) {
            testRecommendedTrails.add(new Recommended_Trail__c(
                Mix_Category__c=testMixCategories[0].Id,
                Trail__c=testTrailMap.values()[i].Id
            ));
        }
        insert testRecommendedTrails;
        Test.stopTest();

        List<Recommended_Trail__c> resultRecommendedTrails = [SELECT Trail__c, Level__c FROM Recommended_Trail__c];

        for(Recommended_Trail__c rt : resultRecommendedTrails) {
            System.assertEquals(
                testTrailMap.get(rt.Trail__c).trailheadapp__Level__c,
                rt.Level__c,
                'Expected Recommended Trail Level to be the same as parent Trail level.'
            );
        }
    }

    @isTest
    private static void testPopulateJunctionPicklists_singleTrailNegative() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Trail__c> testTrails = new List<trailheadapp__Trail__c>{    
            new trailheadapp__Trail__c(
                Name='Test Trail ',
                trailheadapp__Level__c='',
                trailheadapp__API_Name__c='Test_Trail',
                trailheadapp__Description__c='Test Description',
                trailheadapp__Namespace__c='Test Namespace',
                trailheadapp__URL__c='www.test.com',
                trailheadapp__Icon__c='www.testicon.com'
            )
        };
        insert testTrails;

        Test.startTest();
        List<Recommended_Trail__c> testRecommendedTrails = new List<Recommended_Trail__c>{    
            new Recommended_Trail__c(
                Mix_Category__c=testMixCategories[0].Id,
                Trail__c=testTrails[0].Id
            )
        };
        insert testRecommendedTrails;
        Test.stopTest();

        List<Recommended_Trail__c> resultRecommendedTrails = [SELECT Level__c FROM Recommended_Trail__c];
        
        System.assertEquals(
            null,
            resultRecommendedTrails[0].Level__c,
            'Expected Recommended Trail level to be null when parent Trail level is unpopulated.'
        );
    }

    @isTest
    private static void testPopulateJunctionPicklists_bulkTrailsNegative() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Trail__c> testTrails = new List<trailheadapp__Trail__c>{    
            new trailheadapp__Trail__c(
                Name='Test Trail ',
                trailheadapp__Level__c='',
                trailheadapp__API_Name__c='Test_Trail',
                trailheadapp__Description__c='Test Description',
                trailheadapp__Namespace__c='Test Namespace',
                trailheadapp__URL__c='www.test.com',
                trailheadapp__Icon__c='www.testicon.com'
            )
        };
        insert testTrails;

        Map<Id, trailheadapp__Trail__c> testTrailMap = new Map<Id, trailheadapp__Trail__c>([SELECT Id, trailheadapp__Level__c FROM trailheadapp__Trail__c]);

        Test.startTest();
        List<Recommended_Trail__c> testRecommendedTrails = new List<Recommended_Trail__c>();
        for(trailheadapp__Trail__c trail : testTrailMap.values()) {
            testRecommendedTrails.add(new Recommended_Trail__c(
                Mix_Category__c=testMixCategories[0].Id,
                Trail__c=trail.Id
            ));
        }
        insert testRecommendedTrails;
        Test.stopTest();

        List<Recommended_Trail__c> resultRecommendedTrails = [SELECT Trail__c, Level__c FROM Recommended_Trail__c];

        for(Recommended_Trail__c rt : resultRecommendedTrails) {
            System.assertEquals(
                testTrailMap.get(rt.Trail__c).trailheadapp__Level__c, 
                rt.Level__c,
                'Expected Recommended Trail level to be the same as parent Trail level.'
            );
        }
    }

    @isTest
    private static void testPopulateBadgeMixKeys_singlePositiveInsert() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Badge__c> testBadges = [SELECT Id FROM trailheadapp__Badge__c];

        Boolean caughtException = false;

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random()*testBadges.size()));

        try {
            Test.startTest();
            List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
                new Recommended_Badge__c(
                    Mix_Category__c=testMixCategories[0].Id,
                    Badge__c=testBadges[testBadgeIndex].Id
                )
            };
            insert testRecommendedBadges;
            Test.stopTest();
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, 'No exception expected.');
    }

    @isTest
    private static void testPopulateBadgeMixKeys_bulkPositiveInsert() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Badge__c> testBadges = [SELECT Id FROM trailheadapp__Badge__c];

        Boolean caughtException = false;

        try {
            Test.startTest();
            List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
            for(trailheadapp__Badge__c badge : testBadges) {
                testRecommendedBadges.add(new Recommended_Badge__c(
                    Mix_Category__c=testMixCategories[0].Id,
                    Badge__c=badge.Id
                ));
            }
            insert testRecommendedBadges;
            Test.stopTest();
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, 'No exception expected.');
    }

    @isTest
    private static void testPopulateBadgeMixKeys_negativeInsert() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Badge__c> testBadges = [SELECT Id FROM trailheadapp__Badge__c];

        Boolean caughtException = false;
        String exceptionMessage;

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        
        for(Integer i = 0; i < 2; i++) {
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=testBadges[testBadgeIndex].Id
            ));
        }

        try {
            Test.startTest();
            insert testRecommendedBadges;
            Test.stopTest();
        } catch(Exception e) {
            caughtException = true;
            exceptionMessage = e.getMessage();
        }

        System.assert(caughtException, 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        System.assert(exceptionMessage.contains('DUPLICATE_VALUE'), 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
    }

    @isTest
    private static void testPopulateBadgeMixKeys_bulkNegativeInsert() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Badge__c> testBadges = [SELECT Id FROM trailheadapp__Badge__c];

        Boolean caughtException = false;
        String exceptionMessage;

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();

        for(trailheadapp__Badge__c badge : testBadges) {
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=badge.Id
            ));
        }

        testRecommendedBadges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[0].Id,
            Badge__c=testBadges[testBadgeIndex].Id
        ));

        try {
            Test.startTest();
            insert testRecommendedBadges;
            Test.stopTest();
        } catch(Exception e) {
            caughtException = true;
            exceptionMessage = e.getMessage();
        }

        System.assert(caughtException, 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        System.assert(exceptionMessage.contains('DUPLICATE_VALUE'), 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
    }
    
    @isTest
    private static void testPopulateBadgeMixKeys_singlePositiveUpdate() {
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = [SELECT Id FROM Recommended_Badge_Mix__c];

        List<Mix_Category__c> testMixCategories = new List<Mix_Category__c>{    
            new Mix_Category__c(
                Name='Test Mix Category',
                Recommended_Badge_Mix__c=testRecommendedBadgeMixes[0].Id
            )
        };
        insert testMixCategories;

        testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Badge__c> testBadges = [SELECT Id FROM trailheadapp__Badge__c];

        Boolean caughtException = false;

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
            new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=testBadges.remove(testBadgeIndex).Id
            )
        };

        try {
            Test.startTest();
            insert testRecommendedBadges;

            testRecommendedBadges[0].Mix_Category__c=testMixCategories[1].Id;
            update testRecommendedBadges;
            Test.stopTest();
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, 'No exception expected.');
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
        List<trailheadapp__Badge__c> testBadges = [SELECT Id FROM trailheadapp__Badge__c];

        Boolean caughtException = false;
        
        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();

        for(Integer i = 0; i < 200; i++) {
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=testBadges[i].Id
            ));
        }

        try {
            Test.startTest();
            insert testRecommendedBadges;

            for(Integer i = 0; i < 200; i++) {
                testRecommendedBadges[i].Mix_Category__c = testMixCategories[1].Id;
            }

            update testRecommendedBadges;
            Test.stopTest();
        } catch(Exception e) {
            caughtException = true;
            System.debug(e.getMessage());
        }

        System.assert(!caughtException, 'No exception expected.');
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

        List<trailheadapp__Badge__c> testBadges = [SELECT Id FROM trailheadapp__Badge__c];

        Boolean caughtException = false;
        String exceptionMessage;

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        testRecommendedBadges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[0].Id,
            Badge__c=testBadges[testBadgeIndex].Id
        ));
        testRecommendedBadges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[1].Id,
            Badge__c=testBadges[testBadgeIndex].Id
        ));

        try {
            Test.startTest();
            insert testRecommendedBadges;

            testRecommendedBadges[0].Mix_Category__c = testRecommendedBadges[1].Mix_Category__c;
            update testRecommendedBadges;
            Test.stopTest();
        } catch(Exception e) {
            caughtException = true;
            exceptionMessage = e.getMessage();
        }

        System.assert(caughtException, 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        System.assert(exceptionMessage.contains('DUPLICATE_VALUE'), 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
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

        List<trailheadapp__Badge__c> testBadges = [SELECT Id FROM trailheadapp__Badge__c];

        Boolean caughtException = false;
        String exceptionMessage;

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        for(trailheadapp__Badge__c badge : testBadges) {
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=badge.Id
            ));
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[1].Id,
                Badge__c=badge.Id
            ));
        }

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
        } catch(Exception e) {
            caughtException = true;
            exceptionMessage = e.getMessage();
        }

        System.assert(caughtException, 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
        System.assert(exceptionMessage.contains('DUPLICATE_VALUE'), 'Expected exception with duplicate Recommended Badges in one Recommended Badge Mix.');
    }

    @isTest
    private static void testUpdateJunctionTypesAndLevels_singleBadgeLevelChange() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        
        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__Level__c FROM trailheadapp__Badge__c];
        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));
        
        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
            new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=testBadges[testBadgeIndex].Id
            )
        };
        insert testRecommendedBadges;

        Test.startTest();
        String currentLevel = testBadges[testBadgeIndex].trailheadapp__Level__c;
        testBadges[testBadgeIndex].trailheadapp__Level__c = levels.indexOf(currentLevel) == 2 ? levels[0] : levels[levels.indexOf(currentLevel)+1];
        update testBadges;
        Test.stopTest();

        List<Recommended_Badge__c> resultRecommendedBadges = [SELECT Id, Level__c FROM Recommended_Badge__c];
        
        System.assertEquals(
            testBadges[testBadgeIndex].trailheadapp__Level__c, 
            resultRecommendedBadges[0].Level__c, 
            'Expected Recommended Badge level to update to new parent Badge level.'
        );
    }

    @isTest
    private static void testUpdateJunctionTypesAndLevels_singleBadgeTypeChange() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];

        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__Type__c FROM trailheadapp__Badge__c];
        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
            new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=testBadges[testBadgeIndex].Id
            )
        };
        insert testRecommendedBadges;

        Test.startTest();
        String currentType = testBadges[testBadgeIndex].trailheadapp__Type__c;
        testBadges[testBadgeIndex].trailheadapp__Type__c = types.indexOf(currentType) == 2 ? types[0] : types[types.indexOf(currentType)+1];
        update testBadges;
        Test.stopTest();

        List<Recommended_Badge__c> resultRecommendedBadges = [SELECT Id, Type__c FROM Recommended_Badge__c];

        System.assertEquals(
            testBadges[testBadgeIndex].trailheadapp__Type__c,
            resultRecommendedBadges[0].Type__c,
            'Expected Recommended Badge type to update to new parent Badge type.'
        );
    }

    @isTest
    private static void testUpdateJunctionTypesAndLevels_singleBadgeTypeAndLevelChange() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        
        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__Level__c, trailheadapp__Type__c FROM trailheadapp__Badge__c];
        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
            new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=testBadges[testBadgeIndex].Id
            )
        };
        insert testRecommendedBadges;

        Test.startTest();
        String currentLevel = testBadges[testBadgeIndex].trailheadapp__Level__c;
        String currentType = testBadges[testBadgeIndex].trailheadapp__Type__c;
        testBadges[testBadgeIndex].trailheadapp__Level__c = levels.indexOf(currentLevel) == 2 ? levels[0] : levels[levels.indexOf(currentLevel)+1];
        testBadges[testBadgeIndex].trailheadapp__Type__c = types.indexOf(currentType) == 2 ? types[0] : types[types.indexOf(currentType)+1];
        update testBadges;
        Test.stopTest();

        List<Recommended_Badge__c> resultRecommendedBadges = [SELECT Level__c, Type__c FROM Recommended_Badge__c];

        System.assertEquals(
            testBadges[testBadgeIndex].trailheadapp__Level__c, 
            resultRecommendedBadges[0].Level__c,
            'Expected Recommended Badge level to update to new parent Badge level.'
        );
        System.assertEquals(
            testBadges[testBadgeIndex].trailheadapp__Type__c, 
            resultRecommendedBadges[0].Type__c,
            'Expected Recommended Badge type to update to new parent Badge type.'
        );
    }

    @isTest
    private static void testUpdateJunctionTypesAndLevels_singleBadgeNegative() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];

        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__Description__c, trailheadapp__Level__c, trailheadapp__Type__c FROM trailheadapp__Badge__c];
        integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
            new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=testBadges[testBadgeIndex].Id
            )
        };
        insert testRecommendedBadges;

        String originalLevel = testBadges[testBadgeIndex].trailheadapp__Level__c;
        String originalType = testBadges[testBadgeIndex].trailheadapp__Type__c;

        Test.startTest();
        testBadges[testBadgeIndex].trailheadapp__Description__c += ' modified description';
        update testBadges;
        Test.stopTest();

        List<Recommended_Badge__c> resultRecommendedBadges = [SELECT Level__c, Type__c FROM Recommended_Badge__c];

        System.assertEquals(
            originalLevel, 
            resultRecommendedBadges[0].Level__c,
            'Expected Recommended Badge level to be unchanged when parent Badge level is unchanged.'
        );
        System.assertEquals(
            originalType, 
            resultRecommendedBadges[0].Type__c,
            'Expected Recommended Badge type to be unchanged when parent Badge level is unchanged.'
        );
    }

    @isTest
    private static void testUpdateJunctionTypesAndLevels_bulkBadges() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        Map<Id, trailheadapp__Badge__c> testBadgeMap = new Map<Id, trailheadapp__Badge__c>(
            [SELECT Id, trailheadapp__Level__c, trailheadapp__Type__c FROM trailheadapp__Badge__c]
        );
        
        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        for(trailheadapp__Badge__c badge : testBadgeMap.values()) {
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=badge.Id
            ));
        }
        insert testRecommendedBadges;

        Test.startTest();
        for(trailheadapp__Badge__c badge : testBadgeMap.values()) {
            badge.trailheadapp__Level__c = levels.indexOf(badge.trailheadapp__Level__c) == 2 ? levels[0] : levels[levels.indexOf(badge.trailheadapp__Level__c)+1];
            badge.trailheadapp__Type__c = types.indexOf(badge.trailheadapp__Type__c) == 2 ? types[0] : types[types.indexOf(badge.trailheadapp__Type__c)+1];
        }
        update testBadgeMap.values();
        Test.stopTest();

        List<Recommended_Badge__c> resultRecommendedBadges = [SELECT Badge__c, Type__c, Level__c FROM Recommended_Badge__c];

        for(Recommended_Badge__c rb : resultRecommendedBadges) {
            System.assertEquals(
                testBadgeMap.get(rb.Badge__c).trailheadapp__Level__c,
                rb.Level__c,
                'Expected Recommended Badge level to update to new parent Badge level.'
            );
            System.assertEquals(
                testBadgeMap.get(rb.Badge__c).trailheadapp__Type__c, 
                rb.Type__c,
                'Expected Recommended Badge type to update to new parent Badge type.'
            );
        }
    }

    @isTest
    private static void testUpdateJunctionTypesAndLevels_bulkBadgesNegative() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        Map<Id, trailheadapp__Badge__c> testBadgeMap = new Map<Id, trailheadapp__Badge__c>(
            [SELECT Id, trailheadapp__Description__c, trailheadapp__Level__c, trailheadapp__Type__c FROM trailheadapp__Badge__c]
        );

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        for(trailheadapp__Badge__c badge : testBadgeMap.values()) {
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                Badge__c=badge.Id
            ));
        }
        insert testRecommendedBadges;

        Test.startTest();
        for(trailheadapp__Badge__c badge : testBadgeMap.values()) {
            badge.trailheadapp__Description__c += ' modified description';
        }
        update testBadgeMap.values();
        Test.stopTest();

        List<Recommended_Badge__c> resultRecommendedBadges = [SELECT Badge__c, Level__c, Type__c FROM Recommended_Badge__c];

        for(Recommended_Badge__c rb : resultRecommendedBadges) {
            System.assertEquals(
                testBadgeMap.get(rb.Badge__c).trailheadapp__Level__c, 
                rb.Level__c,
                'Expected Recommended Badge level to be unchanged when parent Badge level is unchanged.'
            );
            System.assertEquals(
                testBadgeMap.get(rb.Badge__c).trailheadapp__Type__c, 
                rb.Type__c,
                'Expected Recommended Badge type to be unchanged when parent Badge type is unchanged.'
            );
        }
    }

    @isTest
    private static void testUpdateJunctionTypesAndLevels_singleTrail() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];

        List<trailheadapp__Trail__c> testTrails = [SELECT Id, trailheadapp__Level__c FROM trailheadapp__Trail__c];
        Integer testTrailIndex = Integer.valueOf(Math.floor(Math.random() * testTrails.size()));

        List<Recommended_Trail__c> testRecommendedTrails = new List<Recommended_Trail__c>{
            new Recommended_Trail__c(
                Mix_Category__c=testMixCategories[0].Id,
                Trail__c=testTrails[testTrailIndex].Id
            )
        };
        insert testRecommendedTrails;

        Test.startTest();
        String currentLevel = testTrails[testTrailIndex].trailheadapp__Level__c;
        testTrails[testTrailIndex].trailheadapp__Level__c = levels.indexOf(currentLevel) == 2 ? levels[0] : levels[levels.indexOf(currentLevel)+1];
        update testTrails;
        Test.stopTest();

        List<Recommended_Trail__c> resultRecommendedTrails = [SELECT Level__c FROM Recommended_Trail__c];

        System.assertEquals(
            testTrails[testTrailIndex].trailheadapp__Level__c, 
            resultRecommendedTrails[0].Level__c,
            'Expected Recommended Trail level to update to new parent Trail level.'
        );
    }

    @isTest
    private static void testUpdateJunctionTypesAndLevels_singleTrailNegative() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];

        List<trailheadapp__Trail__c> testTrails = [SELECT Id, trailheadapp__Description__c, trailheadapp__Level__c FROM trailheadapp__Trail__c];
        Integer testTrailIndex = Integer.valueOf(Math.floor(Math.random() * testTrails.size()));

        List<Recommended_Trail__c> testRecommendedTrails = new List<Recommended_Trail__c>{
            new Recommended_Trail__c(
                Mix_Category__c=testMixCategories[0].Id,
                Trail__c=testTrails[testTrailIndex].Id
            )
        };
        insert testRecommendedTrails;

        Test.startTest();
        testTrails[testTrailIndex].trailheadapp__Description__c += ' modified description';
        update testTrails;
        Test.stopTest();

        List<Recommended_Trail__c> resultRecommendedTrails = [SELECT Level__c FROM Recommended_Trail__c];

        System.assertEquals(
            testTrails[testTrailIndex].trailheadapp__Level__c, 
            resultRecommendedTrails[0].Level__c,
            'Expected Recommended Trail level to be unchanged when parent Trail level is unchanged.'
        );
    }

    @isTest
    private static void testUpdateJunctionTypesAndLevels_bulkTrails() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];

        Map<Id, trailheadapp__Trail__c> testTrailMap = new Map<Id, trailheadapp__Trail__c>(
            [SELECT Id, trailheadapp__Level__c FROM trailheadapp__Trail__c]
        );

        List<Recommended_Trail__c> testRecommendedTrails = new List<Recommended_Trail__c>();
        for(trailheadapp__Trail__c trail : testTrailMap.values()) {
            testRecommendedTrails.add(new Recommended_Trail__c(
                Mix_Category__c=testMixCategories[0].Id,
                Trail__c=trail.Id
            ));
        }
        insert testRecommendedTrails;

        Test.startTest();
        String currentLevel;
        for(trailheadapp__Trail__c trail : testTrailMap.values()) {
            trail.trailheadapp__Level__c = levels.indexOf(trail.trailheadapp__Level__c) == 2 ? levels[0] : levels[levels.indexOf(trail.trailheadapp__Level__c)+1];
        }
        update testTrailMap.values();
        Test.stopTest();

        List<Recommended_Trail__c> resultRecommendedTrails = [SELECT Trail__c, Level__c FROM Recommended_Trail__c];
        for(Recommended_Trail__c rt : resultRecommendedTrails) {
            System.assertEquals(
                testTrailMap.get(rt.Trail__c).trailheadapp__Level__c, 
                rt.Level__c,
                'Expected Recommended Trail level to be updated when parent Trail level is updated.'
            );
        }
    }

    @isTest
    private static void testUpdateJunctionTypesAndLevels_bulkTrailsNegative() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        Map<Id, trailheadapp__Trail__c> testTrailMap = new Map<Id, trailheadapp__Trail__c>(
            [SELECT Id, trailheadapp__Description__c, trailheadapp__Level__c FROM trailheadapp__Trail__c]
        );

        List<Recommended_Trail__c> testRecommendedTrails = new List<Recommended_Trail__c>();
        for(trailheadapp__Trail__c trail : testTrailMap.values()) {
            testRecommendedTrails.add(new Recommended_Trail__c(
                Mix_Category__c=testMixCategories[0].Id,
                Trail__c=trail.Id
            ));
        }
        insert testRecommendedTrails;

        Test.startTest();
        for(trailheadapp__Trail__c trail : testTrailMap.values()) {
            trail.trailheadapp__Description__c += ' modified description';
        }
        update testTrailMap.values();
        Test.stopTest();

        List<Recommended_Trail__c> resultRecommendedTrails = [SELECT Trail__c, Level__c FROM Recommended_Trail__c];
        for(Recommended_Trail__c rt : resultRecommendedTrails) {
            System.assertEquals(
                testTrailMap.get(rt.Trail__c).trailheadapp__Level__c, 
                rt.Level__c,
                'Expected Recommended Trail level to be unchanged when parent Trail level is unchanged.'
            );
        }
    }
}

