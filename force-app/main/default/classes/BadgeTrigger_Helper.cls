/**
 * @description       : A catchall trigger helper for TrailTrigger, BadgeTrigger, RecommendedBadgeTrigger, and RecommendedTrailTrigger.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-25-2022
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

    public static void updateJunctionTypesAndLevels(List<sObject> oldRecords, Map<Id, sObject> newRecordMap, String sObjectType) {
        ObjectInfoWrapper parentObjectInfo = OBJECT_INFO_MAP.get(sObjectType);
        List<String> fieldsToCheck = new List<String>(parentObjectInfo.parentJunctionPicklistMap.keySet());

        Set<Id> modifiedParentIds = new Set<Id>();

        for(sObject oldRecord : oldRecords) {
            for(String fieldToCheck : fieldsToCheck) {
                if(oldRecord.get(fieldToCheck) != newRecordMap.get(String.valueOf(oldRecord.get('Id'))).get(fieldToCheck)) {
                    modifiedParentIds.add(String.valueOf(oldRecord.get('Id')));
                }
            }
        }

        String queryString = 'SELECT ' + parentObjectInfo.relationshipFieldName + ', ' + String.join(fieldsToCheck, ', ') + ' FROM ' + parentObjectInfo.childJunctionObjectType +
            ' WHERE ' + parentObjectInfo.relationshipFieldName + ' IN :modifiedParentIds';

        List<sObject> junctionRecordsToUpdate = Database.query(queryString);

        for(sObject junctionRecord : junctionRecordsToUpdate) {
            for(String picklist : parentObjectInfo.parentJunctionPicklistMap.values()) {
                sObject parentRecord = newRecordMap.get(String.valueOf(junctionRecord.get(parentObjectInfo.relationshipFieldName)));
                junctionRecord.put(picklist, parentRecord.get(picklist));
            }
        }

        update junctionRecordsToUpdate;
    }

    public static void populateJunctionPicklists(List<sObject> newRecords, String sObjectType) {
        ObjectInfoWrapper childObject = OBJECT_INFO_MAP.get(sObjectType);
        Map<String, String> picklists = childObject.parentJunctionPicklistMap;

        Set<Id> parentIdsToQuery = new Set<Id>();

        for(sObject newRecord : newRecords) {
            parentIdsToQuery.add(String.valueOf(newRecord.get(String.valueOf(childObject.relationshipFieldName))));
        }

        String queryString = 'SELECT ' + String.join(new List<String>(picklists.keySet()), ', ') + ' FROM ' + childObject.parentObjectType + 
            ' WHERE Id IN :parentIdsToQuery';

        System.debug(queryString);
        Map<Id, sObject> parentRecordMap = new Map<Id, sObject>(Database.query(queryString));

        for(sObject newRecord : newRecords) {
            for(String parentPicklist : picklists.keySet()) {
                String parentPicklistValue = String.valueOf(parentRecordMap.get(String.valueOf(newRecord.get(childObject.relationshipFieldName))).get(parentPicklist));
                newRecord.put(picklists.get(String.valueOf(parentPicklist)), parentPicklistValue);
            }
        }
    }
}