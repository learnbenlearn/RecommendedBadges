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

    @isTest
    private static void selectAll_test() {
        List<DefaultServiceImplementation__mdt> expectedDefaultServiceImplementations = [SELECT DeveloperName, DefaultImplementation__c FROM DefaultServiceImplementation__mdt];
        List<DefaultServiceImplementation__mdt> resultDefaultServiceImplementations = new DefaultServiceImplementationsSelector().selectAll();
        Assert.areEqual(expectedDefaultServiceImplementations, resultDefaultServiceImplementations, 'Expected all DefaultServiceImplementation records to be returned.');
    }
}