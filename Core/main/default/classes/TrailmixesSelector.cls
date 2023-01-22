/**
 * @description       : Selector class for the Trailmix custom object from the Trail Tracker managed package.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class TrailmixesSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            trailheadapp__Trailmix__c.Id
        };
    }

    public Schema.SObjectType getSObjectType() {
        return trailheadapp__Trailmix__c.sObjectType;
    }
}