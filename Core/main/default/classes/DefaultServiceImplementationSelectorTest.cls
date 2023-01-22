/**
 * @description       : Test class for DefaultServiceImplementationsSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class DefaultServiceImplementationSelectorTest {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            DefaultServiceImplementation__mdt.DeveloperName,
            DefaultServiceImplementation__mdt.DefaultImplementation__c
        };

        Assert.areEqual(expectedFieldList, new DefaultServiceImplementationsSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(DefaultServiceImplementation__mdt.sObjectType, new DefaultServiceImplementationsSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }
}