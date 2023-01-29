/**
 * @description       : Selector class for Recommended Badge Mix custom object.
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
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

    public override ApplicationSelector enableFieldSet(Schema.FieldSet fieldSet) {
        return (RecommendedBadgeMixesSelector) super.enableFieldSet(fieldSet);
    }

    public List<Recommended_Badge_Mix__c> selectDefaultMixes() {
        return this.selectExistingDefaultMixes(null);
    }

    public List<Recommended_Badge_Mix__c> selectExistingDefaultMixes(List<Id> mixIdsToExclude) {
        if(mixIdsToExclude != null) {
            return (List<Recommended_Badge_Mix__c>) Database.query(
                newQueryFactory().
                setCondition('Id NOT IN :midIdsToExclude AND Default_Badge_Mix__c=true').
                toSOQL()
            );
        } else {
            return (List<Recommended_Badge_Mix__c>) Database.query(newQueryFactory().setCondition('Default_Badge_Mix__c=true').toSOQL());
        }
    }
}