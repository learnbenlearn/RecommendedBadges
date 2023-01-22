/**
 * @description       : Selector class for Badge to Keep custom metadata type.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class BadgesToKeepSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Badge_to_Keep__mdt.Badge_Name__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Badge_to_Keep__mdt.sObjectType;
    }
}