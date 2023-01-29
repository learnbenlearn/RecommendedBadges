/**
 * @description       : Selector class for the Badge custom object from the Trail Tracker managed package.
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
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

    public List<trailheadapp__Badge__c> selectAllArchivedOrInProductsToDelete(List<String> badgeProductsToDelete) {
        return (List<trailheadapp__Badge__c>) Database.query(
            newQueryFactory().
            setCondition('trailheadapp__Products__c IN :badgeProductsToDelete OR trailheadapp__Archived__c=true').
            toSOQL()
        );
    }

    public List<trailheadapp__Badge__c> selectById(Set<Id> badgeIds) {
        return (List<trailheadapp__Badge__c>) Database.query(
            newQueryFactory().
            selectFieldSet(Schema.SObjectType.trailheadapp__Badge__c.fieldSets.Triggers).
            setCondition('Id IN :badgeIds').
            toSOQL()
        );
    }
}