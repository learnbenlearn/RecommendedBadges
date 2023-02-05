/**
 * @description       : Test class for DefaultObjectSelectorsSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
 * @last modified by  : Ben Learn
**/
@isTest
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
}