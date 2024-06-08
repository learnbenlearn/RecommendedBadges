/**
 * @description       : A catchall trigger helper for RecommendedBadgeTrigger and RecommendedTrailTrigger.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 03-05-2023
 * @last modified by  : Ben Learn
**/
public without sharing class BadgeTrigger_Helper {
    /**
    * @description Method to populate unique key in the format [Badge Name]-[Recommended Badge Mix Name].
        Done to ensure that there aren't any duplicated recommended badges within the same recommended
        badge mix.
    * @author Ben Learn | 03-11-2022 
    * @param List<Recommended_Badge__c> newRecommendedBadges 
    * @param Map<Id, Recommended_Badge__c> oldRecommendedBadgeMap
    **/
    public static void populateBadgeMixKeys(List<Recommended_Badge__c> newRecommendedBadges, Map<Id, Recommended_Badge__c> oldRecommendedBadgeMap) {
        Set<Id> mixCategoryIds = new Set<Id>();

        for(Recommended_Badge__c newRecommendedBadge : newRecommendedBadges) {
            if(
                (newRecommendedBadge.Badge_Mix_Key__c == null) || 
                (oldRecommendedBadgeMap?.get(newRecommendedBadge.Id).Mix_Category__c != newRecommendedBadge.Mix_Category__c)
            ) {
                mixCategoryIds.add(newRecommendedBadge.Mix_Category__c);
            }
        }

        Map<Id, Mix_Category__c> mixCategoryMap = new Map<Id, Mix_Category__c>(new MixCategoriesSelector().selectByIdWithRecommendedBadgeMixNames(mixCategoryIds));
        for(Recommended_Badge__c newRecommendedBadge : newRecommendedBadges) {
            if(
                (newRecommendedBadge.Badge_Mix_Key__c == null) || 
                (oldRecommendedBadgeMap?.get(newRecommendedBadge.Id).Mix_Category__c != newRecommendedBadge.Mix_Category__c)
            ){
                String recommendedBadgeMixName = mixCategoryMap.get(newRecommendedBadge.Mix_Category__c).Recommended_Badge_Mix__r.Name;
                newRecommendedBadge.Badge_Mix_Key__c = newRecommendedBadge.BadgeAPIName__c + '-' + recommendedBadgeMixName; // change this
            }
        }
    }
}