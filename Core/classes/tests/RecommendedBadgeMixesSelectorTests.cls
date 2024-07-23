@isTest(IsParallel=true)
private class RecommendedBadgeMixesSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            Recommended_Badge_Mix__c.Id,
            Recommended_Badge_Mix__c.Name
        };

        Assert.areEqual(expectedFieldList, new RecommendedBadgeMixesSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(Recommended_Badge_Mix__c.sObjectType, new RecommendedBadgeMixesSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    private static Id generateData() {
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{
            'generateRecordIDs' => false,
            'generatorReturnValue' => 'all',
            'numberToGenerate' => 9
        });
        badgeMixGenerator.generate();
        badgeMixGenerator.numberToGenerate = 1;
        List<Recommended_Badge_Mix__c> badgeMixes = (List<Recommended_Badge_Mix__c>) badgeMixGenerator.setFieldSpec(
            new TestSupport.TestDataField(Recommended_Badge_Mix__c.Default_Badge_Mix__c, true)
        ).generate();
        insert badgeMixes;
        
        Id defaultBadgeMixId;
        for(Recommended_Badge_Mix__c rbm : badgeMixes) {
            if(rbm.Default_Badge_Mix__c) {
                defaultBadgeMixId = rbm.Id;
                break;
            }
        }

        return defaultBadgeMixId;
    }

    @isTest
    private static void selectDefaultMix_test() {
        Id defaultBadgeMixId = generateData();
        List<Recommended_Badge_Mix__c> resultRecommendedBadgeMixes = new RecommendedBadgeMixesSelector().selectDefaultMix();
        Assert.isTrue(resultRecommendedBadgeMixes.size() == 1, 'There should only be one default Recommended Badge Mix.');
        Assert.areEqual(defaultBadgeMixId, resultRecommendedBadgeMixes[0].Id, 'Expected default Recommended Badge Mix to have provided ID.');
    }

    @isTest
    private static void selectDefaultMix_testIncludingFieldSetFields() {
        Id defaultBadgeMixId = generateData();
        List<Recommended_Badge_Mix__c> resultRecommendedBadgeMixes = new RecommendedBadgeMixesSelector(true).selectDefaultMix();
        Assert.isTrue(resultRecommendedBadgeMixes.size() == 1, 'There should only be one default Recommended Badge Mix.');
        Assert.areEqual(defaultBadgeMixId, resultRecommendedBadgeMixes[0].Id, 'Expected default Recommended Badge Mix to have provided ID.');
    }

    @isTest
    private static void selectExistingDefaultMix_test() {
        Id defaultBadgeMixId = generateData();
        Map<Id, Recommended_Badge_Mix__c> nonDefaultRecommendedBadgeMixesById = new Map<Id, Recommended_Badge_Mix__c>([
            SELECT Id FROM Recommended_Badge_Mix__c WHERE Default_Badge_Mix__c = false
        ]);
        List<Recommended_Badge_Mix__c> resultRecommendedBadgeMixes = new RecommendedBadgeMixesSelector().selectExistingDefaultMix(
            new List<Id>(nonDefaultRecommendedBadgeMixesById.keySet())
        );
        Assert.isTrue(resultRecommendedBadgeMixes.size() == 1, 'There should only be one default Recommended Badge Mix.');
        Assert.areEqual(defaultBadgeMixId, resultRecommendedBadgeMixes[0].Id, 'Expected default Recommended Badge Mix to have provided ID.');

    }
}