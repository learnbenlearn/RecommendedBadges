/**
 * @description       : Schedulable Apex class to clear storage space by deleting unused records created by Trail Tracker app.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-27-2022
 * @last modified by  : Ben Learn
**/
public without sharing class ScheduledStorageClean implements Schedulable {
    final static String methodName = 'startAsync';

    public void execute(SchedulableContext sc) {
        List<AsyncApexJob> asyncJobs = [SELECT Id, Status, JobType, LastProcessed, MethodName, FORMAT(CompletedDate) FROM AsyncApexJob
            WHERE CompletedDate=TODAY AND MethodName = :methodName];

        if(asyncJobs.size() > 0){
            StorageManagementService.clean();
        }
    }
}
