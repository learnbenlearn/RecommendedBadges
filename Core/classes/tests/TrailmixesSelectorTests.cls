/**
 * @description       : Test class for TrailmixesSelector.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class TrailmixesSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            trailheadapp__Trailmix__c.Id
        };

        Assert.areEqual(expectedFieldList, new TrailmixesSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(trailheadapp__Trailmix__c.sObjectType, new TrailmixesSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectAll_test() {
        TestDataFactory.Trailmix trailmixGenerator = new TestDataFactory.Trailmix(true, true);
        Map<Id, trailheadapp__Trailmix__c> expectedTrailmixesById = new Map<Id, trailheadapp__Trailmix__c>((List<trailheadapp__Trailmix__c>) trailmixGenerator.execute());
        Map<Id, trailheadapp__Trailmix__c> resultTrailmixesById = new Map<Id, trailheadapp__Trailmix__c>(new TrailmixesSelector().selectAll());
        Assert.areEqual(expectedTrailmixesById.keySet(), resultTrailmixesById.keySet(), 'Expected all Trailmixes to be retrieved.');
    }
}