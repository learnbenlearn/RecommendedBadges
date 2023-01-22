/**
 * @description       : Selector class for Recommended Badge Mix custom object.
 * @author            : Ben Learn
 * @last modified on  : 01-21-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class RecommendedBadgeMixesSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Recommended_Badge_Mix__c.Id,
            Recommended_Badge_Mix__c.Name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Recommended_Badge_Mix__c.sObjectType;
    }
}