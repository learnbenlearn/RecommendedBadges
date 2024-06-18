/**
 * @description       : Selector class for Recommended Badge Mix custom object.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class RecommendedBadgeMixesSelector extends ApplicationSelector {
    public RecommendedBadgeMixesSelector() {
        this(false);
    }

    public RecommendedBadgeMixesSelector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
    }

    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Recommended_Badge_Mix__c.Id,
            Recommended_Badge_Mix__c.Name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Recommended_Badge_Mix__c.sObjectType;
    }

    public List<Recommended_Badge_Mix__c> selectDefaultMix() {
        return this.selectExistingDefaultMix(null);
    }

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