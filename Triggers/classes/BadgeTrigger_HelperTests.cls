/**
 * @description       : Test class for BadgeTrigger_Helper class.
 * @author            : Ben Learn
 * @last modified on  : 02-20-2023
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
        TestDataFactory.Badge badgeGenerator = new TestDataFactory.Badge(true, false);
        badgeGenerator.execute();

        TestDataFactory.Trail trailGenerator = new TestDataFactory.Trail(true, false);
        trailGenerator.execute();

        TestDataFactory.RecommendedBadgeMix recommendedBadgeMixGenerator = new TestDataFactory.RecommendedBadgeMix(true, true, 1, false, true);
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = recommendedBadgeMixGenerator.execute();

        TestDataFactory.MixCategory mixCategoryGenerator = new TestDataFactory.MixCategory(true, false, 1, testRecommendedBadgeMixes);
        mixCategoryGenerator.execute();
    }

    @isTest
    private static void testPopulateBadgeMixKeys_singlePositiveInsert() {
        List<Mix_Category__c> testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__API_Name__c FROM trailheadapp__Badge__c];

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random()*testBadges.size()));

        try {
            Test.startTest();
            List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
                new Recommended_Badge__c(
                    Mix_Category__c=testMixCategories[0].Id,
                    BadgeAPIName__c=testBadges[testBadgeIndex].trailheadapp__API_Name__c
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
        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__API_Name__c FROM trailheadapp__Badge__c];

        try {
            Test.startTest();
            TestDataFactory.RecommendedBadge recommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(
                true, false, testBadges, new List<Mix_Category__c>{testMixCategories[0]}, true
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
        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__API_Name__c FROM trailheadapp__Badge__c];

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));
        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        for(Integer i = 0; i < 2; i++) {
            testRecommendedBadges.add(new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                BadgeAPIName__c=testBadges[testBadgeIndex].trailheadapp__API_Name__c
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
        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__API_Name__c FROM trailheadapp__Badge__c];

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));

        TestDataFactory.RecommendedBadge recommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(
            false, true, testBadges, new List<Mix_Category__c>{testMixCategories[0]}, true
        );
        List<Recommended_Badge__c> testRecommendedBadges = recommendedBadgeGenerator.execute();
        testRecommendedBadges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[0].Id,
            BadgeAPIName__c=testBadges[testBadgeIndex].trailheadapp__API_Name__c
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
            )
        };
        insert testMixCategories;

        testMixCategories = [SELECT Id FROM Mix_Category__c];
        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__API_Name__c FROM trailheadapp__Badge__c];

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>{
            new Recommended_Badge__c(
                Mix_Category__c=testMixCategories[0].Id,
                BadgeAPIName__c=testBadges.remove(testBadgeIndex).trailheadapp__API_Name__c
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
        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__API_Name__c FROM trailheadapp__Badge__c];
        
        TestDataFactory.RecommendedBadge recommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(
            false, true, testBadges, new List<Mix_Category__c>{testMixCategories[0]}, true
        );
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

        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__API_Name__c FROM trailheadapp__Badge__c];

        Integer testBadgeIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        testRecommendedBadges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[0].Id,
            BadgeAPIName__c=testBadges[testBadgeIndex].trailheadapp__API_Name__c
        ));
        testRecommendedBadges.add(new Recommended_Badge__c(
            Mix_Category__c=testMixCategories[1].Id,
            BadgeAPIName__c=testBadges[testBadgeIndex].trailheadapp__API_Name__c
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

        List<trailheadapp__Badge__c> testBadges = [SELECT Id, trailheadapp__API_Name__c FROM trailheadapp__Badge__c];

        TestDataFactory.RecommendedBadge recommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(
            false, true, testBadges, new List<Mix_Category__c>{testMixCategories[0]}, true
        );
        List<Recommended_Badge__c> testRecommendedBadges = recommendedBadgeGenerator.execute();
        TestDataFactory.RecommendedBadge duplicateRecommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(
            false, true, testBadges, new List<Mix_Category__c>{testMixCategories[1]}, true
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
}