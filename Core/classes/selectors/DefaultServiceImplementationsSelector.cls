/**
 * Selector class for Default Service Implementation custom metadata type.
 * @author Ben Learn
 * @since 01-22-2023
 * @group Core
 */
public inherited sharing class DefaultServiceImplementationsSelector extends ApplicationSelector {
    /**
     * fflib method to hold the fields to always be queried by the selector
     * @return  `List<Schema.SObjectField>`
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            DefaultServiceImplementation__mdt.DeveloperName,
            DefaultServiceImplementation__mdt.DefaultImplementation__c
        };
    }

    /**
     * fflib method to return the sObjectType of the object being queried
     * @return  `Schema.SObjectType`
     */    
    public Schema.SObjectType getSObjectType() {
        return DefaultServiceImplementation__mdt.sObjectType;
    }

    /**
     * returns all DefaultServiceImplementation__mdt records
     * @return  `List<DefaultServiceImplementation__mdt>`
     */
    public List<DefaultServiceImplementation__mdt> selectAll() {
        return (List<DefaultServiceImplementation__mdt>) Database.query(newQueryFactory().toSOQL());
    }
}