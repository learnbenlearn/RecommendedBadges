/**
 * @description       : Test class for TaskListController.
 * @author            : Ben Learn
 * @last modified on  : 12-30-2022
 * @last modified by  : Ben Learn
**/
@isTest
private class TaskListControllerTests {
    @TestSetup
    static void makeData(){
        List<Task> tasks = new List<Task>();

        for(Integer i = 0; i < 400; i++) {
            if(Math.mod(i, 2) == 0) {
                tasks.add(new Task(Status='Not Started'));
            } else {
                tasks.add(new Task(Status='Completed'));
            }
        }

        insert tasks;
    }
    
    @isTest
    static void testGetTasks() {
        Test.startTest();
        List<Task> openTasks = TaskListService.getTasks();
        Test.stopTest();

        System.assertEquals(200, openTasks.size(), 'Should have 200 open tasks.');
    }

    @isTest
    static void testGetTasksRestrictedUser() {
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
            List<Task> openTasks = TaskListService.getTasks();
            Test.stopTest();

            System.assertEquals(0, openTasks.size(), 'No tasks should be accessible to restricted user.');
        }
    }
}
