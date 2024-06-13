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
    private static void selectTrailAPINameById_test() {
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{'numberToGenerate' => 1, 'generateRecordIDs' => false});
        insert badgeMixGenerator.generate();
        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object>{'numberToGenerate' => 10, 'generateMasterRecords' => false, 'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, sObject>(badgeMixGenerator.records)).keySet())}
        );
        insert mixCategoryGenerator.generate();
        RecommendedTrailTS recommendedTrailGenerator = new RecommendedTrailTS(
            new Map<String, Object>{'generateMasterRecords' => false, 'generateRecordIDs' => false},
            new List<TestSupport.TestDataField>{new RelationshipField(Recommended_Trail__c.Mix_Category__c, (new Map<Id, sObject>(mixCategoryGenerator.records)).keySet())}
        );
        insert recommendedTrailGenerator.generate();

        Recommended_Trail__c expectedTrail = [SELECT Id, TrailAPIName__c FROM Recommended_Trail__c LIMIT 1];

        Test.startTest();
        String trailAPIName = new RecommendedTrailsSelector().selectTrailAPINameById(expectedTrail.Id).TrailAPIName__c;
        Test.stopTest();

        Assert.areEqual(expectedTrail.TrailAPIName__c, trailAPIName, 'Expected Trail API Name of corresponding Recommended Trail to be returned.');
    }
}