@isTest(IsParallel=true)
private class TrailheadEntityURLMappingsSelector_Tests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            TrailheadEntityURLMapping__mdt.DefaultPath__c,
            TrailheadEntityURLMapping__mdt.TrailheadEntityType__c,
            TrailheadEntityURLMapping__mdt.TrailheadPath__c
        };

        Assert.areEqual(expectedFieldList, new TrailheadEntityURLMappingsSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(TrailheadEntityURLMapping__mdt.sObjectType, new TrailheadEntityURLMappingsSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectAll_test() {
        Map<Id, TrailheadEntityURLMapping__mdt> expectedURLMappingsById = new Map<Id, TrailheadEntityURLMapping__mdt>([SELECT Id FROM TrailheadEntityURLMapping__mdt]);
        Map<Id, TrailheadEntityURLMapping__mdt> resultURLMappingsById = new Map<Id, TrailheadEntityURLMapping__mdt>(new TrailheadEntityURLMappingsSelector().selectAll());

        Assert.areEqual(expectedURLMappingsById.keySet(), resultURLMappingsById.keySet(), 'Expected all TrailheadEntityURLMapping records to be returned.');
    }
}