/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 12-25-2022
 * @last modified by  : Ben Learn
**/
@isTest
private class ScheduledStorageCleanTests {
    private static final String CRON = '0 0 0 * * ?';

    @isTest
    private static void execute_test() {
        Test.startTest();
        String jobId = System.schedule('Test', CRON, new ScheduledStorageClean());
        Test.stopTest();

        List<CronTrigger> testJobs = [SELECT Id, State FROM CronTrigger WHERE Id =: jobId];
        System.assert(testJobs.size() == 1, 'Expected job to be scheduled.');
    }

    @isTest
    private static void execute_testNegativeWithAsyncApexJob() {
        AsyncApexJobsSelector mockAsyncApexJobsSelector = (AsyncApexJobsSelector) ScheduledStorageCleanMockUtils.createMock(AsyncApexJobsSelector.class);

        Test.startTest();
        String jobId = System.schedule('Test', CRON, new ScheduledStorageClean());
        Test.stopTest();

        List<CronTrigger> testJobs = [SELECT Id, State FROM CronTrigger WHERE Id =: jobId];
        System.assert(testJobs.size() == 1, 'Expected job to be scheduled.');
    }
}
