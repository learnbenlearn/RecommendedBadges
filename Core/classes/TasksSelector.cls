/**
 * @description       : Selector for Task standard object.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class TasksSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Task.Id,
            Task.Subject
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Task.sObjectType;
    }

    public List<Task> selectOpen() {
        return (List<Task>) Database.query(newQueryFactory().setCondition('IsClosed=false').toSOQL());
    }
}