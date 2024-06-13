/**
 * @description       : Selector class for Recommended Badge custom object.
 * @author            : Ben Learn
 * @last modified on  : 02-16-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class RecommendedBadgesSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Recommended_Badge__c.Id,
            Recommended_Badge__c.Level__c,
            Recommended_Badge__c.Type__c
        };
    }

    public Schema.sObjectType getSObjectType() {
        return Recommended_Badge__c.sObjectType;
    }

    public List<Recommended_Badge__c> selectedAllRelatedToUserPrivateMix() {
        fflib_QueryFactory recommendedBadgesQueryFactory = newQueryFactory();

        new MixCategoriesSelector().configureQueryFactoryFields(recommendedBadgesQueryFactory, Recommended_Badge__c.Mix_Category__c.getDescribe().getRelationshipName());

        return (List<Recommended_Badge__c>) Database.query(
            recommendedBadgesQueryFactory.selectFieldSet(Schema.SObjectType.Recommended_Badge__c.fieldSets.PrivateMixView, true).
            setCondition('Mix_Category__r.Recommended_Badge_Mix__r.Private_Mix__c = true AND Mix_Category__r.Recommended_Badge_Mix__r.OwnerId = \'' + UserInfo.getUserId() + '\'').
            setOrdering(new fflib_QueryFactory.Ordering(
                this.getSObjectType().getDescribe().getName(), 
                Schema.SObjectType.Recommended_Badge__c.fields.Badge_Name__c.getName(), 
                fflib_QueryFactory.SortOrder.ASCENDING
            )).
            toSOQL()
        );
    }

    public Recommended_Badge__c selectBadgeAPINameById(Id recommendedBadgeId) {
        return (Recommended_Badge__c) Database.query(
            newQueryFactory().selectFieldSet(Schema.SObjectType.Recommended_Badge__c.fieldSets.Triggers, false).
            setCondition('Id = \'' + recommendedBadgeId + '\'').
            toSOQL()
        )[0];
    }
}