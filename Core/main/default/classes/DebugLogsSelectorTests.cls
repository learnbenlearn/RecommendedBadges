/**
 * @description       : Test class for DebugLogsSelector.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class DebugLogsSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            trailheadapp__Debug_Log__c.Id
        };

        Assert.areEqual(expectedFieldList, new DebugLogsSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(trailheadapp__Debug_Log__c.sObjectType, new DebugLogsSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectAll_test() {
        TestDataFactory.DebugLog debugLogGenerator = new TestDataFactory.DebugLog(true, true);
        Map<Id, trailheadapp__Debug_Log__c> expectedDebugLogsById = new Map<Id, trailheadapp__Debug_Log__c>((List<trailheadapp__Debug_Log__c>) debugLogGenerator.execute());
        Map<Id, trailheadapp__Debug_Log__c> resultDebugLogsById = new Map<Id, trailheadapp__Debug_Log__c>(new DebugLogsSelector().selectAll());
        Assert.areEqual(expectedDebugLogsById.keySet(), resultDebugLogsById.keySet(), 'Expected all Debug Logs to be retrieved.');
    }
}