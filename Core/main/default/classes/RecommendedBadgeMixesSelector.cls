/**
 * @description       : 
 * @author            : Ben Learn
 * @last modified on  : 01-20-2023
 * @last modified by  : Ben Learn
**/
public with sharing class RecommendedBadgeMixesSelector extends fflib_SObjectSelector {
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