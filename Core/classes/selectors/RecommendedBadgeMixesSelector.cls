/**
 * Selector class for Recommended Badge Mix custom object.
 * @author Ben Learn
 * @since 02-05-2023
 * @group Core
 */
public inherited sharing class RecommendedBadgeMixesSelector extends ApplicationSelector {
    @SuppressWarnings('PMD.ApexDoc')
    public RecommendedBadgeMixesSelector() {
        this(false);
    }

    @SuppressWarnings('PMD.ApexDoc')
    public RecommendedBadgeMixesSelector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
    }

    /**
     * fflib method to hold the fields to always be queried by the selector
     * @return  `List<Schema.SObjectField>`
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Recommended_Badge_Mix__c.Id,
            Recommended_Badge_Mix__c.Name
        };
    }

    /**
     * fflib method to return the sObjectType of the object being queried
     * @return  `Schema.SObjectType`
     */
    public Schema.SObjectType getSObjectType() {
        return Recommended_Badge_Mix__c.sObjectType;
    }

    /**
     * Returns default Recommended_Badge_Mix__c
     * @return  `List<Recommended_Badge_Mix__c>`
     */
    public List<Recommended_Badge_Mix__c> selectDefaultMix() {
        return this.selectExistingDefaultMix(null);
    }

    /**
     * Returns default Recommended_Badge_Mix__c. If mixIdsToExclude is not null, filters out Recommended_Badge_Mix__c records with matching IDs
     * @param mixIdsToExclude 
     * @return  `List<Recommended_Badge_Mix__c>`
     */
    public List<Recommended_Badge_Mix__c> selectExistingDefaultMix(List<Id> mixIdsToExclude) {
        if(mixIdsToExclude != null) {
            return (List<Recommended_Badge_Mix__c>) Database.query(
                newQueryFactory().
                setCondition('Id NOT IN :mixIdsToExclude AND Default_Badge_Mix__c=true').
                toSOQL()
            );
        } else {
            return (List<Recommended_Badge_Mix__c>) Database.query(newQueryFactory().setCondition('Default_Badge_Mix__c=true').toSOQL());
        }
    }
}