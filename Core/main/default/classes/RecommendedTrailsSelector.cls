/**
 * @description       : Selector class for Recommended Trail custom object.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
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
}