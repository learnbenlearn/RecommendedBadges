/**
 * @description       : Selector class for the Debug Log custom object from the Trail Tracker managed package.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class DebugLogsSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            trailheadapp__Debug_Log__c.Id
        };
    }

    public Schema.SObjectType getSObjectType() {
        return trailheadapp__Debug_Log__c.sObjectType;
    }

    public List<trailheadapp__Debug_Log__c> selectAll() {
        return (List<trailheadapp__Debug_Log__c>) Database.query(newQueryFactory().toSOQL());
    }
}