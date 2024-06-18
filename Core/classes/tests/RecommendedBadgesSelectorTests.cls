/**
 * @description       : Test class for RecommendedBadgesSelector.
 * @author            : Ben Learn
 * @last modified on  : 02-20-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class RecommendedBadgesSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            Recommended_Badge__c.Id,
            Recommended_Badge__c.Level__c,
            Recommended_Badge__c.Type__c
        };

        Assert.areEqual(expectedFieldList, new RecommendedBadgesSelector().getSObjectFieldList(), 'Expected prescribed field list.');
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(Recommended_Badge__c.sObjectType, new RecommendedBadgesSelector().getSObjectType(), 'Expected prescribed sObjectType.');
    }

    private static List<Recommended_Badge__c> generateData(Boolean returnRecommendedBadges) {        
        TestDataFactory.RecommendedBadgeMix recommendedBadgeMixGenerator = new TestDataFactory.RecommendedBadgeMix(true, true);
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = (List<Recommended_Badge_Mix__c>) recommendedBadgeMixGenerator.execute();

        TestDataFactory.MixCategory mixCategoryGenerator = new TestDataFactory.MixCategory(true, true, testRecommendedBadgeMixes);
        List<Mix_Category__c> testMixCategories = (List<Mix_Category__c>) mixCategoryGenerator.execute();

        TestDataFactory.RecommendedBadge recommendedBadgeGenerator = new TestDataFactory.RecommendedBadge(true, returnRecommendedBadges, testMixCategories, true);
        return recommendedBadgeGenerator.execute();
    }

    @isTest
    private static void selectedAllRelatedToUserPrivateMix_test() {
        generateData(false);
        Map<Id, Recommended_Badge__c> expectedRecommendedBadgesById = new Map<Id, Recommended_Badge__c>([
            SELECT Id FROM Recommended_Badge__c WHERE Mix_Category__r.Recommended_Badge_Mix__r.Private_Mix__c = true
        ]);
        Map<Id, Recommended_Badge__c> resultRecommendedBadgesById = new Map<Id, Recommended_Badge__c>(
            new RecommendedBadgesSelector().selectedAllRelatedToUserPrivateMix()
        );
        Assert.areEqual(
            expectedRecommendedBadgesById.keySet(), 
            resultRecommendedBadgesById.keySet(), 
            'Expected only Recommended Badges related to private Recommended Badge Mixes to be returned.'
        );
    }

    @isTest
    private static void selectBadgeAPINameById_test() {
        generateData(false);
        Recommended_Badge__c expectedBadge = [SELECT Id, BadgeAPIName__c FROM Recommended_Badge__c LIMIT 1];
        Assert.areEqual(
            expectedBadge.BadgeAPIName__c, 
            new RecommendedBadgesSelector().selectBadgeAPINameById(expectedBadge.Id).BadgeAPIName__c,
            'Expected Badge API Name of corresponding Recommended Badge to be returned.'
        );
    }

    @isTest
    private static void selectBadgesByAPINames_test() {
        List<Recommended_Badge__c> testBadges = generateData(true);
        Map<Id, String> selectorBadgeAPINamesByID = new Map<Id, String>();
        Integer selectedIndex;
        for(Integer i = 0; i < 10; i++) {
            selectedIndex = Integer.valueOf(Math.floor(Math.random() * testBadges.size()));
            selectorBadgeAPINamesByID.put(testBadges[selectedIndex].Id, testBadges[selectedIndex].BadgeAPIName__c);
        }

        Test.startTest();
        Map<Id, Recommended_Badge__c> resultBadges = new Map<Id, Recommended_Badge__c>(
            new RecommendedBadgesSelector().selectBadgesByAPINames(new Set<String>(selectorBadgeAPINamesByID.values()))
        );
        Test.stopTest();

        Assert.areEqual(selectorBadgeAPINamesByID.keySet(), resultBadges.keySet(), 'Expected Recommended Badges with provided API names to be returned.');
    }
}