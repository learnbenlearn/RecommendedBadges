/**
 * @description       : Apex controller for taskList LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 01-14-2023
 * @last modified by  : Ben Learn
**/
public with sharing class TaskListController {
    /**
    * @description Method to return all open tasks for taskList LWC.
    * @author Ben Learn | 03-11-2022 
    * @return List<Task> 
    **/
    @AuraEnabled(cacheable=true)
    public static List<Task> getTasks() {
        List<Task> tasks = [SELECT Id, Subject FROM Task WHERE IsClosed = false];
        return tasks;
    }
}
