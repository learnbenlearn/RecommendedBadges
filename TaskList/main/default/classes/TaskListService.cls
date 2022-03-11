/**
 * @description       : Apex controller for taskList LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 03-11-2022
 * @last modified by  : Ben Learn
**/
public without sharing class TaskListService {
    @AuraEnabled(cacheable=true)
    public static List<Task> getTasks() {
        List<Task> tasks = [SELECT Id, Subject FROM Task WHERE IsClosed = false];
        return tasks;
    }
}
