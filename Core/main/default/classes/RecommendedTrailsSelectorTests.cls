/**
 * @description       : Test class for RecommendedTrailsSelector.
 * @author            : Ben Learn
 * @last modified on  : 02-20-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class RecommendedTrailsSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            Recommended_Trail__c.Id,
            Recommended_Trail__c.Level__c
        };

        Assert.areEqual(expectedFieldList, new RecommendedTrailsSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(Recommended_Trail__c.sObjectType, new RecommendedTrailsSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectByTrails_test() {
        TestDataFactory.RecommendedBadgeMix recommendedBadgeMixGenerator = new TestDataFactory.RecommendedBadgeMix(true, true, 1, false, true);
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = (List<Recommended_Badge_Mix__c>) recommendedBadgeMixGenerator.execute();

        TestDataFactory.MixCategory mixCategoryGenerator = new TestDataFactory.MixCategory(true, true, 1, testRecommendedBadgeMixes);
        List<Mix_Category__c> testMixCategories = (List<Mix_Category__c>) mixCategoryGenerator.execute();

        TestDataFactory.Trail trailGenerator = new TestDataFactory.Trail(true, true);
        Map<Id, trailheadapp__Trail__c> testTrailsById = new Map<Id, trailheadapp__Trail__c>((List<trailheadapp__Trail__c>) trailGenerator.execute());

        TestDataFactory.RecommendedTrail recommendedTrailGenerator = new TestDataFactory.RecommendedTrail(true, false, testTrailsById.values(), testMixCategories, true);
        recommendedTrailGenerator.execute();

        Set<Id> expectedTrailIds = new Set<Id>();
        Integer counter = 0;

        for(Id trailId : testTrailsById.keySet()) {
            if(counter >= testTrailsById.size() / 2) break;
            expectedTrailIds.add(trailId);
            counter += 1;
        }

        List<Recommended_Trail__c> resultRecommendedTrails = new RecommendedTrailsSelector().selectByTrails(expectedTrailIds);

        for(Recommended_Trail__c recommendedTrail : resultRecommendedTrails) {
            Assert.isTrue(expectedTrailIds.contains(recommendedTrail.Trail__c), 'Expected all Recommended Trails related to provided Trails to be returned.');
            expectedTrailIds.remove(recommendedTrail.Trail__c);
        }

        Assert.isTrue(expectedTrailIds.size() == 0, 'Expected only Recommended Trails related to provided Trails to be returned.');
    }
}