/**
 * @description       : Test class for TaskListController.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class TaskListControllerTests {
    @isTest
    static void testGetTasks() {
        TestDataFactory.Task taskGenerator = new TestDataFactory.Task(true, false, 400);
        taskGenerator.execute();
        Test.startTest();
        List<Task> openTasks = TaskListController.getTasks();
        Test.stopTest();

        System.assertEquals(200, openTasks.size(), 'Should have 200 open tasks.');
    }

    @isTest
    static void testGetTasksRestrictedUser() {
        TestDataFactory.Task taskGenerator = new TestDataFactory.Task(true, false, 400);
        Profile minimumAccess = [SELECT Id FROM Profile WHERE Name='Minimum Access - Salesforce'];
        User u = new User(
            firstName = 'Test',
            LastName = 'User',
            Alias = 'tuser',
            Email = 'tuser@test.com',
            UserName='test'+ Math.random().format()+'user@test.com',
            EmailEncodingKey = 'ISO-8859-1',
            LanguageLocaleKey = 'en_US',
            TimeZoneSidKey = 'America/Los_Angeles',
            LocaleSidKey = 'en_US',
            ProfileId = minimumAccess.Id,
            IsActive=true
        );

        System.runAs(u) {
            Test.startTest();
            List<Task> openTasks = TaskListController.getTasks();
            Test.stopTest();

            System.assertEquals(0, openTasks.size(), 'No tasks should be accessible to restricted user.');
        }
    }
}
