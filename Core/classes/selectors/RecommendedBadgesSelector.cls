/**
 * Selector class for Recommended Badge custom object.
 * @author Ben Learn
 * @since 02-16-2023
 * @group Core
 */
public inherited sharing class RecommendedBadgesSelector extends ApplicationSelector {
    /**
     * fflib method to hold the fields to always be queried by the selector
     * @return  `List<Schema.SObjectField>`
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Recommended_Badge__c.Id,
            Recommended_Badge__c.Level__c,
            Recommended_Badge__c.Type__c
        };
    }

    /**
     * fflib method to return the sObjectType of the object being queried
     * @return  `Schema.SObjectType`
     */
    public Schema.sObjectType getSObjectType() {
        return Recommended_Badge__c.sObjectType;
    }

    /**
     * Returns all Recommended_Badge__c records that have a matching BadgeAPIName__c, including fields in the Core field set
     * @param badgeAPINames 
     * @return  `List<Recommended_Badge__c>`
     */
    public List<Recommended_Badge__c> selectBadgesByAPINames(Set<String> badgeAPINames) {
        return (List<Recommended_Badge__c>) Database.query(
            newQueryFactory().selectFieldSet(Schema.SObjectType.Recommended_Badge__c.fieldSets.Core, false).
            setCondition('BadgeAPIName__c IN :badgeAPINames').
            toSOQL()
        );
    }

    /**
     * Returns all Recommended_Badge__c records related to the private mix of the running user, including fields from the PrivateMixView field set
     * @return  `List<Recommended_Badge__c>`
     */
    public List<Recommended_Badge__c> selectedAllRelatedToUserPrivateMix() {
        fflib_QueryFactory recommendedBadgesQueryFactory = newQueryFactory();

        new MixCategoriesSelector().configureQueryFactoryFields(recommendedBadgesQueryFactory, Recommended_Badge__c.Mix_Category__c.getDescribe().getRelationshipName());

        return (List<Recommended_Badge__c>) Database.query(
            recommendedBadgesQueryFactory.selectFieldSet(Schema.SObjectType.Recommended_Badge__c.fieldSets.PrivateMixView, true).
            setCondition('Mix_Category__r.Recommended_Badge_Mix__r.Private_Mix__c = true AND Mix_Category__r.Recommended_Badge_Mix__r.OwnerId = \'' + UserInfo.getUserId() + '\'').
            setOrdering(new fflib_QueryFactory.Ordering(
                this.getSObjectType().getDescribe().getName(), 
                Schema.SObjectType.Recommended_Badge__c.fields.BadgeName__c.getName(), 
                fflib_QueryFactory.SortOrder.ASCENDING
            )).
            toSOQL()
        );
    }

    /**
     * Returns the API name of the Recommended_Badge__c with the provided Id by including fields from the Triggers field set
     * @param recommendedBadgeId 
     * @return  `Recommended_Badge__c`
     */
    public Recommended_Badge__c selectBadgeAPINameById(Id recommendedBadgeId) {
        return (Recommended_Badge__c) Database.query(
            newQueryFactory().selectFieldSet(Schema.SObjectType.Recommended_Badge__c.fieldSets.Triggers, false).
            setCondition('Id = \'' + recommendedBadgeId + '\'').
            toSOQL()
        )[0];
    }
}