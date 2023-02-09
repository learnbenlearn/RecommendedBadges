/**
 * @description       : Selector class for Default Object Selector custom metadata type.
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class DefaultObjectSelectorsSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            DefaultObjectSelector__mdt.DeveloperName,
            DefaultObjectSelector__mdt.DefaultSelector__c,
            DefaultObjectSelector__mdt.Suffix__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return DefaultObjectSelector__mdt.sObjectType;
    }

    public List<DefaultObjectSelector__mdt> selectAll() {
        return (List<DefaultObjectSelector__mdt>) Database.query(newQueryFactory().toSOQL());
    }
}