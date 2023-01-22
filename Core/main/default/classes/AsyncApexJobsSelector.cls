/**
 * @description       : Selector class for Async Apex Job object.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class AsyncApexJobsSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            AsyncApexJob.Id
        };
    }

    public Schema.SObjectType getSObjectType() {
        return AsyncApexJob.sObjectType;
    }
}