/**
 * @description       : Selector class for Recommended Badge custom object.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class RecommendedBadgesSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Recommended_Badge__c.Level__c,
            Recommended_Badge__c.Type__c
        };
    }

    public Schema.sObjectType getSObjectType() {
        return Recommended_Badge__c.sObjectType;
    }
}