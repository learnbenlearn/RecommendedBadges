/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 12-25-2022
 * @last modified by  : Ben Learn
**/
@isTest
private class ScheduledStorageCleanTests {
    @isTest
    private static void executeTest() {
        String cron = '0 0 0 * * ?';
        Test.startTest();
        String jobId = System.schedule('Test', cron, new ScheduledStorageClean());
        Test.stopTest();

        List<CronTrigger> testJobs = [SELECT Id, State FROM CronTrigger WHERE Id =: jobId];
        System.assert(testJobs.size() == 1, 'Expected job to be scheduled.');
    }
}
