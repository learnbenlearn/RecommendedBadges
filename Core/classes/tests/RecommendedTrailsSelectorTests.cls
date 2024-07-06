@isTest(IsParallel=true)
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

    private static void generateData() {        
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
    }

    @isTest
    private static void selectTrailAPINameById_test() {
        generateData();
        Recommended_Trail__c expectedTrail = [SELECT Id, TrailAPIName__c FROM Recommended_Trail__c LIMIT 1];

        Test.startTest();
        String trailAPIName = new RecommendedTrailsSelector().selectTrailAPINameById(expectedTrail.Id).TrailAPIName__c;
        Test.stopTest();

        Assert.areEqual(expectedTrail.TrailAPIName__c, trailAPIName, 'Expected Trail API Name of corresponding Recommended Trail to be returned.');
    }

    @isTest
    private static void selectTrailsByAPINames() {
        generateData();

        Map<Id, Recommended_Trail__c> expectedTrails = new Map<Id, Recommended_Trail__c>([SELECT Id, TrailAPIName__c FROM Recommended_Trail__c LIMIT 10]);
        Set<String> trailAPINames = new Set<String>();
        for(Recommended_Trail__c trail : expectedTrails.values()) {
            trailAPINames.add(trail.TrailAPIName__c);
        }

        Test.startTest();
        Map<Id, Recommended_Trail__c> resultTrails = new Map<Id, Recommended_Trail__c>(new RecommendedTrailsSelector().selectTrailsByAPINames(trailAPINames));
        Test.stopTest();

        Assert.areEqual(expectedTrails.keySet(), resultTrails.keySet(), 'Expected Recommended Trails with provided API names to be returned.');
    }
}