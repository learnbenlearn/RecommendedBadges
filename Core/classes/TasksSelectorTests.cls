/**
 * @description       : Test class for TasksSelector.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
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

    @isTest
    private static void selectOpen_test() {
        TestDataFactory.Task taskGenerator = new TestDataFactory.Task(true, true);
        List<Task> testTasks = (List<Task>) taskGenerator.execute();

        Assert.areEqual(testTasks.size() / 2, new TasksSelector().selectOpen().size(), 'Expected only open Tasks to be retrieved.');
    }
}