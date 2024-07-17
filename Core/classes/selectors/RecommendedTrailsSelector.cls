/**
 * Selector class for Recommended Trail custom object.
 * @author Ben Learn
 * @since 01-29-2023
 * @group Core
 */
public inherited sharing class RecommendedTrailsSelector extends ApplicationSelector {
    /**
     * fflib method to hold the fields to always be queried by the selector
     * @return  `List<Schema.SObjectField>`
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Recommended_Trail__c.Id,
            Recommended_Trail__c.Level__c
        };
    }

    /**
     * fflib method to return the sObjectType of the object being queried
     * @return  `Schema.SObjectType`
     */    
    public Schema.SObjectType getSObjectType() {
        return Recommended_Trail__c.sObjectType;
    }

    /**
     * default constructor
     */    
    public RecommendedTrailsSelector() {
        super();
    }

    /**
     * constructor to call fflib_SObjectSelector constructor with/without field set fields included and using specified DataAccess
     * @param includeFieldSetFields 
     * @param dataAccess 
     */
    public RecommendedTrailsSelector(Boolean includeFieldSetFields, fflib_SObjectSelector.DataAccess dataAccess) {
        super(includeFieldSetFields, dataAccess);
    }

    /**
     * Returns all Recommended_Trail__c records that have a matching TrailAPIName__c, including fields in the Core field set
     * @param trailAPINames 
     * @return  `List<Recommended_Trail__c>`
     */
    public List<Recommended_Trail__c> selectTrailsByAPINames(Set<String> trailAPINames) {
        return (List<Recommended_Trail__c>) Database.query(
            newQueryFactory().selectFieldSet(Schema.SObjectType.Recommended_Trail__c.fieldSets.Core, false).
            setCondition('TrailAPIName__c IN :trailAPINames').
            toSOQL()
        );
    }

    /**
     * Returns the API name of the Recommended_Trail__c with the provided Id by including fields from the Triggers field set
     * @param recommendedTrailId 
     * @return  `Recommended_Trail__c`
     */
    public Recommended_Trail__c selectTrailAPINameById(Id recommendedTrailId) {
        return (Recommended_Trail__c) Database.query(
            newQueryFactory().selectFieldSet(Schema.SObjectType.Recommended_Trail__c.fieldSets.Triggers, false).
            setCondition('Id = \'' + recommendedTrailId + '\'').
            toSOQL()
        )[0];
    }
}