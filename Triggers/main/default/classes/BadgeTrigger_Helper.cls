/**
 * @description       : A catchall trigger helper for TrailTrigger, BadgeTrigger, RecommendedBadgeTrigger, and RecommendedTrailTrigger.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 01-29-2023
 * @last modified by  : Ben Learn
**/
public without sharing class BadgeTrigger_Helper {
    public static final Map<String, ObjectInfoWrapper> OBJECT_INFO_MAP;

    static {
        OBJECT_INFO_MAP = new Map<String, ObjectInfoWrapper>();

        Map<String, String> badgeParentChildPicklists = new Map<String, String>();
        badgeParentChildPicklists.put('trailheadapp__Level__c', 'Level__c');
        badgeParentChildPicklists.put('trailheadapp__Type__c', 'Type__c');
        
        Map<String, String> trailParentChildPicklists = new Map<String, String>();
        trailParentChildPicklists.put('trailheadapp__Level__c', 'Level__c');

        OBJECT_INFO_MAP.put('trailheadapp__Badge__c', new ObjectInfoWrapper(badgeParentChildPicklists, 'Recommended_Badge__c', true, 'Badge__c'));
        OBJECT_INFO_MAP.put('trailheadapp__Trail__c', new ObjectInfoWrapper(trailParentChildPicklists, 'Recommended_Trail__c', true, 'Trail__c'));
        OBJECT_INFO_MAP.put('Recommended_Badge__c', new ObjectInfoWrapper(badgeParentChildPicklists, 'trailheadapp__Badge__c', false, 'Badge__c'));
        OBJECT_INFO_MAP.put('Recommended_Trail__c', new ObjectInfoWrapper(trailParentChildPicklists, 'trailheadapp__Trail__c', false, 'Trail__c'));
    }

    private class ObjectInfoWrapper {
        Map<String, String> parentJunctionPicklistMap;
        String childJunctionObjectType;
        String parentObjectType;
        String relationshipFieldName;

        private ObjectInfoWrapper(Map<String, String> parentJunctionPicklistMap, String objectType, Boolean mappedToParentObject, String relationshipFieldName) {
            this.parentJunctionPicklistMap = parentJunctionPicklistMap;
            this.relationshipFieldName = relationshipFieldName;
            
            if(mappedToParentObject) {
                this.childJunctionObjectType = objectType;
            } else {
                this.parentObjectType = objectType;
            }
        }
    }

    /**
    * @description Method to copy Level__c and Type__c field values from parent trailheadapp__Badge__c/
        trailheadapp__Trail__c to child Recommended_Badge__c/Recommended_Trail__c, respectively, after
        the parent is updated. (Necessary because these fields are picklist fields, so formula fields
        can't be used to copy their values from a parent to a child).
    * @author Ben Learn | 03-11-2022 
    * @param List<sObject> oldRecords 
    * @param Map<Id sObject> newRecordMap 
    * @param String sObjectType 
    **/
    public static void updateJunctionTypesAndLevels(List<sObject> oldRecords, Map<Id, sObject> newRecordMap, String sObjectType) {
        ObjectInfoWrapper parentObjectInfo = OBJECT_INFO_MAP.get(sObjectType);
        List<String> fieldsToCheck = new List<String>(parentObjectInfo.parentJunctionPicklistMap.keySet());

        Set<Id> modifiedParentIds = new Set<Id>();
        for(sObject oldRecord : oldRecords) {
            if(!Boolean.valueOf(oldRecord.get('trailheadapp__Archived__c'))) {
                for(String fieldToCheck : fieldsToCheck) {
                    if(oldRecord.get(fieldToCheck) != newRecordMap.get(String.valueOf(oldRecord.get('Id'))).get(fieldToCheck)) {
                        modifiedParentIds.add(String.valueOf(oldRecord.get('Id')));
                    }
                }
            }
        }

        List<sObject> junctionRecordsToUpdate;
        if(sObjectType == Schema.SObjectType.trailheadapp__Badge__c.getName()) {
            junctionRecordsToUpdate = new RecommendedBadgesSelector().selectByBadges(modifiedParentIds);
        } else if(sObjectType == Schema.SObjectType.trailheadapp__Trail__c.getName()) {
            junctionRecordsToUpdate = new RecommendedTrailsSelector().selectByTrails(modifiedParentIds);
        }

        for(sObject junctionRecord : junctionRecordsToUpdate) {
            for(String picklist : parentObjectInfo.parentJunctionPicklistMap.keySet()) {
                sObject parentRecord = newRecordMap.get(String.valueOf(junctionRecord.get(parentObjectInfo.relationshipFieldName)));
                junctionRecord.put(parentObjectInfo.parentJunctionPicklistMap.get(picklist), parentRecord.get(picklist));
            }
        }

        update junctionRecordsToUpdate;
    }

    /**
    * @description Method to copy Level__c and Type__c field values from parent trailheadapp__Badge__c/
        trialheadapp__Trail__c to child Recommended_Badge__c/Recommended_Trail__c, respectively, before
        the child is created. (Necessary because these fields are picklist fields, so formula fields 
        can't be used to copy their values from a parent to a child).
    * @author Ben Learn | 03-11-2022 
    * @param List<sObject> newRecords 
    * @param String sObjectType 
    **/
    public static void populateJunctionPicklists(List<sObject> newRecords, String sObjectType) {
        ObjectInfoWrapper childObject = OBJECT_INFO_MAP.get(sObjectType);
        Map<String, String> picklists = childObject.parentJunctionPicklistMap;

        Set<Id> parentIdsToQuery = new Set<Id>();
        for(sObject newRecord : newRecords) {
            parentIdsToQuery.add(String.valueOf(newRecord.get(String.valueOf(childObject.relationshipFieldName))));
        }

        Map<Id, sObject> parentRecordMap;
        if(sObjectType == Schema.SObjectType.Recommended_Badge__c.getName()) {
            parentRecordMap = new Map<Id, sObject>(new BadgesSelector().selectById(parentIdsToQuery));
        } else if(sObjectType == Schema.SObjectType.Recommended_Trail__c.getName()) {
            parentRecordMap = new Map<Id, sObject>(new TrailsSelector().selectById(parentIdsToQuery));
        }

        for(sObject newRecord : newRecords) {
            for(String parentPicklist : picklists.keySet()) {
                String parentPicklistValue = String.valueOf(parentRecordMap.get(String.valueOf(newRecord.get(childObject.relationshipFieldName))).get(parentPicklist));
                newRecord.put(picklists.get(String.valueOf(parentPicklist)), parentPicklistValue);
            }
        }
    }

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
                newRecommendedBadge.Badge_Mix_Key__c = newRecommendedBadge.Badge_Name__c + '-' + recommendedBadgeMixName;
            }
        }
    }
}