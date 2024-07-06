/**
 * Selector class for Default Object Selector custom metadata type.
 * @author Ben Learn
 * @since 01-29-2023
 */
public inherited sharing class DefaultObjectSelectorsSelector extends ApplicationSelector {
    /**
     * fflib method to hold the fields to always be queried by the selector
     * @return  `List<Schema.SObjectField>`
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            DefaultObjectSelector__mdt.DeveloperName,
            DefaultObjectSelector__mdt.DefaultSelector__c,
            DefaultObjectSelector__mdt.Suffix__c
        };
    }

    /**
     * fflib method to return the sObjectType of the object being queried
     * @return  `Schema.SObjectType`
     */    
    public Schema.SObjectType getSObjectType() {
        return DefaultObjectSelector__mdt.sObjectType;
    }

    /**
     * returns all DefaultObjectSelector__mdt records
     * @return  `List<DefaultObjectSelector__mdt>`
     */    
    public List<DefaultObjectSelector__mdt> selectAll() {
        return (List<DefaultObjectSelector__mdt>) Database.query(newQueryFactory().toSOQL());
    }
}