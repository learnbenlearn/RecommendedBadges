/**
 * Selector class for Trailhead Entity URL Mapping custom metadata type.
 * @author Ben Learn
 * @since 07-15-2024
 * @group Core
 */
public inherited sharing class TrailheadEntityURLMappingsSelector extends ApplicationSelector {
    /**
     * fflib method to hold the fields to always be queried by the selector
     * @return  `List<Schema.SObjectField>`
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField>{
            TrailheadEntityURLMapping__mdt.DefaultPath__c,
            TrailheadEntityURLMapping__mdt.TrailheadEntityType__c,
            TrailheadEntityURLMapping__mdt.TrailheadPath__c
        };
    }

    /**
     * fflib method to return the sObjectType of the object being queried
     * @return  `Schema.SObjectType`
     */    
    public Schema.SObjectType getSObjectType() {
        return TrailheadEntityURLMapping__mdt.sObjectType;
    }

    /**
     * returns all TrailheadEntityURLMapping__mdt records
     * @return  `List<TrailheadEntityURLMapping__mdt>`
     */    
    public List<TrailheadEntityURLMapping__mdt> selectAll() {
        return (List<TrailheadEntityURLMapping__mdt>) Database.query(newQueryFactory().toSOQL());
    }
}