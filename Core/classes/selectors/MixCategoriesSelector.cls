/**
 * Selector class for Mix Category custom object.
 * @author Ben Learn
 * @since 02-16-2023
 * @group Core
 */
public inherited sharing class MixCategoriesSelector extends ApplicationSelector {
    /**
     * fflib method to hold the fields to always be queried by the selector
     * @return  `List<Schema.SObjectField>`
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Mix_Category__c.Id,
            Mix_Category__c.Name
        };
    }
    
    /**
     * fflib method to return the sObjectType of the object being queried
     * @return  `Schema.SObjectType`
     */
    public Schema.SObjectType getSObjectType() {
        return Mix_Category__c.sObjectType;
    }

    /**
     * Selector method to return Mix Category and parent Recommended Badge Mix Name for provided mixCategoryIds.
     * @param mixCategoryIds 
     * @return  `List<Mix_Category__c>`
     */    
    public List<Mix_Category__c> selectByIdWithRecommendedBadgeMixNames(Set<Id> mixCategoryIds) {
        fflib_QueryFactory mixCategoriesQueryFactory = newQueryFactory();

        new RecommendedBadgeMixesSelector().configureQueryFactoryFields(
            mixCategoriesQueryFactory,
            Mix_Category__c.Recommended_Badge_Mix__c.getDescribe().getRelationshipName()
        );
        
        return (List<Mix_Category__c>) Database.query(mixCategoriesQueryFactory.setCondition('Id IN :mixCategoryIds').toSOQL());
    }

    /**
     * Selector method to return Mix Category and value of Private Mix field on parent Recommended Badge Mix for provided mixCategoryIds.
     * @param mixCategoryIds 
     * @return  `List<Mix_Category__c>`
     */    
    public List<Mix_Category__c> selectByIdWithRecommendedBadgeMixPrivateMix(Set<Id> mixCategoryIds) {
        fflib_QueryFactory mixCategoriesQueryFactory = newQueryFactory();
        
        new RecommendedBadgeMixesSelector().configureQueryFactoryFields(
            mixCategoriesQueryFactory, 
            Mix_Category__c.Recommended_Badge_Mix__c.getDescribe().getRelationshipName()
        );
        
        return (List<Mix_Category__c>) Database.query(
            mixCategoriesQueryFactory.selectFieldSet(Schema.SObjectType.Mix_Category__c.fieldSets.Triggers, true).
            setCondition('Id IN :mixCategoryIds').
            toSOQL()
        );
    }

    /**
     * Selector method to return all Mix Category records (including fields from psecified field set) that are related to either a public Recommended Badge Mix or a private
     * Recommended Badge Mix owned by the running user.
     * @param fieldSet 
     * @return  `List<Mix_Category__c>`
     */    
    public List<Mix_Category__c> selectAllWithRecommendedBadgeMixInfos(Schema.FieldSet fieldSet) {
        fflib_QueryFactory mixCategoriesQueryFactory = newQueryFactory();
        new RecommendedBadgeMixesSelector().configureQueryFactoryFields(mixCategoriesQueryFactory, Mix_Category__c.Recommended_Badge_Mix__c.getDescribe().getRelationshipName());

        if(fieldSet != null) {
            mixCategoriesQueryFactory.selectFieldSet(fieldSet, true);
        }
        
        return (List<Mix_Category__c>) Database.query(
            mixCategoriesQueryFactory
            .setCondition(
                'Recommended_Badge_Mix__r.Private_Mix__c = false OR (Recommended_Badge_Mix__r.Private_Mix__c = true AND Recommended_Badge_Mix__r.OwnerId = \'' + 
                UserInfo.getUserId() + 
                '\')'
            )
            .toSOQL()
        );
    }

    /**
     * Selector method to return all Mix Category records related to a non-private Recommended Badge Mix, along with children Recommended Badges and Recommended Trails, as well
     * as parent Recommended Badge Mix information.
     * @return  `List<Mix_Category__c>`
     */    
    public List<Mix_Category__c> selectRecommendedBadgesAndTrails() {
        fflib_QueryFactory mixCategoriesQueryFactory = newQueryFactory();
        fflib_QueryFactory recommendedBadgesQueryFactory;
        fflib_QueryFactory recommendedTrailsQueryFactory;

        List<Schema.ChildRelationship> mixCategoriesChildRelationships = Schema.SObjectType.Mix_Category__c.getChildRelationships();
        for(Schema.ChildRelationship childRelationship : mixCategoriesChildRelationships) {
            if(childRelationship.getChildSObject() == Recommended_Badge__c.sObjectType) {
                recommendedBadgesQueryFactory = new RecommendedBadgesSelector().
                    addQueryFactorySubselect(mixCategoriesQueryFactory, childRelationship.getRelationshipName(), true).
                    selectFieldSet(Schema.SObjectType.Recommended_Badge__c.fieldSets.RecommendedBadgeMix, true).
                    selectField('HyperlinkedName__c');
            } else if(childRelationship.getChildSObject() == Recommended_Trail__c.sObjectType) {
                recommendedTrailsQueryFactory = new RecommendedTrailsSelector().
                    addQueryFactorySubselect(mixCategoriesQueryFactory, childRelationship.getRelationshipName(), true).
                    selectFieldSet(Schema.SObjectType.Recommended_Trail__c.fieldSets.RecommendedBadgeMix, true).
                    selectField('HyperlinkedName__c'); 
            }
        }

        new RecommendedBadgeMixesSelector().configureQueryFactoryFields(
            mixCategoriesQueryFactory, 
            Mix_Category__c.Recommended_Badge_Mix__c.getDescribe().getRelationshipName()
        );

        return (List<Mix_Category__c>) Database.query(
            mixCategoriesQueryFactory.selectFieldSet(Schema.SObjectType.Mix_Category__c.fieldSets.RecommendedBadgeMix).
            setCondition('Recommended_Badge_Mix__r.Private_Mix__c = false').toSOQL()
        );
    }
}    
