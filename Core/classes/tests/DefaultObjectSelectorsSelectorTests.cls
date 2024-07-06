@isTest(IsParallel=true)
private class DefaultObjectSelectorsSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            DefaultObjectSelector__mdt.DeveloperName,
            DefaultObjectSelector__mdt.DefaultSelector__c,
            DefaultObjectSelector__mdt.Suffix__c
        };

        Assert.areEqual(expectedFieldList, new DefaultObjectSelectorsSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(DefaultObjectSelector__mdt.sObjectType, new DefaultObjectSelectorsSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectAll_test() {
        Map<Id, DefaultObjectSelector__mdt> expectedDefaultObjectSelectorsById = new Map<Id, DefaultObjectSelector__mdt>([SELECT Id FROM DefaultObjectSelector__mdt]);
        Map<Id, DefaultObjectSelector__mdt> resultDefaultObjectSelectorsById = new Map<Id, DefaultObjectSelector__mdt>(new DefaultObjectSelectorsSelector().selectAll());

        Assert.areEqual(expectedDefaultObjectSelectorsById.keySet(), resultDefaultObjectSelectorsById.keySet(), 'Expected all DefaultObjectSelector records to be returned.');
    }
}