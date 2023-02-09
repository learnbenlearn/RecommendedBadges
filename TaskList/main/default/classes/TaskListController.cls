/**
 * @description       : Apex controller for taskList LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 01-29-2023
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
        return new TasksSelector().selectOpen();
    }
}
