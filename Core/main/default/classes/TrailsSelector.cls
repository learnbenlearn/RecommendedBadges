/**
 * @description       : Selector class for the Trail custom object from the Trail Tracker managed package.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class TrailsSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            trailheadapp__Trail__c.Id
        };
    }

    public Schema.SObjectType getSObjectType() {
        return trailheadapp__Trail__c.sObjectType;
    }
}