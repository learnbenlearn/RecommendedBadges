/**
 * @description       : Selector class for the User Badge custom object from the Trail Tracker managed package.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class UserBadgesSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            trailheadapp__User_Badge__c.Id
        };
    }

    public Schema.SObjectType getSObjectType() {
        return trailheadapp__User_Badge__c.sObjectType;
    }

    public List<trailheadapp__User_Badge__c> selectAll() {
        return (List<trailheadapp__User_Badge__c>) Database.query(newQueryFactory().toSOQL());
    }
}