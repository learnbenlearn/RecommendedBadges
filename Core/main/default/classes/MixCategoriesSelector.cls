/**
 * @description       : Selector class for Mix Category custom object.
 * @author            : Ben Learn
 * @last modified on  : 02-07-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class MixCategoriesSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Mix_Category__c.Id,
            Mix_Category__c.Name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Mix_Category__c.sObjectType;
    }

    public List<Mix_Category__c> selectByIdWithRecommendedBadgeMixNames(Set<Id> mixCategoryIds) {
        fflib_QueryFactory mixCategoriesQueryFactory = newQueryFactory();

        new RecommendedBadgeMixesSelector().configureQueryFactoryFields(
            mixCategoriesQueryFactory,
            Mix_Category__c.Recommended_Badge_Mix__c.getDescribe().getRelationshipName()
        );
        
        return (List<Mix_Category__c>) Database.query(mixCategoriesQueryFactory.setCondition('Id IN :mixCategoryIds').toSOQL());
    }

    public List<Mix_Category__c> selectAllWithRecommendedBadgeMixInfos(Schema.FieldSet fieldSet) {
        fflib_QueryFactory mixCategoriesQueryFactory = newQueryFactory();

        if(fieldSet != null) {
            new RecommendedBadgeMixesSelector().configureQueryFactoryFields(
                mixCategoriesQueryFactory,
                Mix_Category__c.Recommended_Badge_Mix__c.getDescribe().getRelationshipName()
            );
            mixCategoriesQueryFactory.selectFieldSet(fieldSet, true);
        } else {
            new RecommendedBadgeMixesSelector().configureQueryFactoryFields(
                mixCategoriesQueryFactory, 
                Mix_Category__c.Recommended_Badge_Mix__c.getDescribe().getRelationshipName()
            );
        }
        
        return (List<Mix_Category__c>) Database.query(mixCategoriesQueryFactory.toSOQL());
    }

    public List<Mix_Category__c> selectRecommendedBadgesAndTrails() {
        fflib_QueryFactory mixCategoriesQueryFactory = newQueryFactory();
        fflib_QueryFactory recommendedBadgesQueryFactory;
        fflib_QueryFactory recommendedTrailsQueryFactory;

        List<Schema.ChildRelationship> mixCategoriesChildRelationships = Schema.SObjectType.Mix_Category__c.getChildRelationships();
        for(Schema.ChildRelationship childRelationship : mixCategoriesChildRelationships) {
            if(childRelationship.getChildSObject() == Recommended_Badge__c.sObjectType) {
                recommendedBadgesQueryFactory = new RecommendedBadgesSelector().
                    addQueryFactorySubselect(mixCategoriesQueryFactory, childRelationship.getRelationshipName(), true).
                    selectFieldSet(Schema.SObjectType.Recommended_Badge__c.fieldSets.RecommendedBadgeMix, true);
            } else if(childRelationship.getChildSObject() == Recommended_Trail__c.sObjectType) {
                recommendedTrailsQueryFactory = new RecommendedTrailsSelector().
                    addQueryFactorySubselect(mixCategoriesQueryFactory, childRelationship.getRelationshipName(), true).
                    selectFieldSet(Schema.SObjectType.Recommended_Trail__c.fieldSets.RecommendedBadgeMix, true); 
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
