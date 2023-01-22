/**
 * @description       : Selector class for the Badge custom object from the Trail Tracker managed package.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class BadgesSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            trailheadapp__Badge__c.Id
        };
    }

    public Schema.SObjectType getSObjectType() {
        return trailheadapp__Badge__c.sObjectType;
    }
}