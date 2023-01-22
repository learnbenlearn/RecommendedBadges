/**
 * @description       : Test class for TasksSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class TasksSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            Task.Id,
            Task.Subject
        };

        Assert.areEqual(expectedFieldList, new TasksSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(Task.sObjectType, new TasksSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }
}