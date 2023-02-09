/**
 * @description       : Selector class for Default Service Implementation custom metadata type.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class DefaultServiceImplementationsSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            DefaultServiceImplementation__mdt.DeveloperName,
            DefaultServiceImplementation__mdt.DefaultImplementation__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return DefaultServiceImplementation__mdt.sObjectType;
    }

    public List<DefaultServiceImplementation__mdt> selectAll() {
        return (List<DefaultServiceImplementation__mdt>) Database.query(newQueryFactory().toSOQL());
    }
}