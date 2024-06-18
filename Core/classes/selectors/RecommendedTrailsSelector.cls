/**
 * @description       : Selector class for Recommended Trail custom object.
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class RecommendedTrailsSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Recommended_Trail__c.Id,
            Recommended_Trail__c.Level__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Recommended_Trail__c.sObjectType;
    }

    public List<Recommended_Trail__c> selectTrailsByAPINames(Set<String> trailAPINames) {
        return (List<Recommended_Trail__c>) Database.query(
            newQueryFactory().selectFieldSet(Schema.SObjectType.Recommended_Trail__c.fieldSets.Core, false).
            setCondition('TrailAPIName__c IN :trailAPINames').
            toSOQL()
        );
    }

    public Recommended_Trail__c selectTrailAPINameById(Id recommendedTrailId) {
        return (Recommended_Trail__c) Database.query(
            newQueryFactory().selectFieldSet(Schema.SObjectType.Recommended_Trail__c.fieldSets.Triggers, false).
            setCondition('Id = \'' + recommendedTrailId + '\'').
            toSOQL()
        )[0];
    }
}