/**
 * @description       : Selector class for the Trail custom object from the Trail Tracker managed package.
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
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

    public List<trailheadapp__Trail__c> selectAllArchivedOrInProductsToDelete(List<String> trailProductsToDelete) {
        return (List<trailheadapp__Trail__c>) Database.query(
            newQueryFactory().
            setCondition('trailheadapp__Products__c IN :trailProductsToDelete OR trailheadapp__Archived__c=true').
            toSOQL()
        );
    }

    public List<trailheadapp__Trail__c> selectById(Set<Id> trailIds) {
        return (List<trailheadapp__Trail__c>) Database.query(
            newQueryFactory().
            selectFieldSet(Schema.SObjectType.trailheadapp__Trail__c.fieldSets.Triggers).
            setCondition('Id IN :trailIds').
            toSOQL()
        );
    }
}