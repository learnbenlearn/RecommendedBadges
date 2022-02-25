/**
 * @description       : A catchall trigger helper for TrailTrigger, BadgeTrigger, RecommendedBadgeTrigger, and RecommendedTrailTrigger.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-25-2022
 * @last modified by  : Ben Learn
**/
public without sharing class BadgeTrigger_Helper {
    public static final Map<String, ObjectInfoWrapper> objectInfoMap;

    static {
        objectInfoMap = new Map<String, ObjectInfoWrapper>();

        Map<String, String> badgeJunctionPicklists = new Map<String, String>();
        badgeJunctionPicklists.put('trailheadapp__Level__c', 'Level__c');
        badgeJunctionPicklists.put('trailheadapp__Type__c', 'Type__c');
        
        Map<String, String> trailJunctionPicklists = new Map<String, String>();
        trailJunctionPicklists.put('trailheadapp__Level__c', 'Level__c');

        objectInfoMap.put('trailheadapp__Badge__c', new ObjectInfoWrapper(badgeJunctionPicklists, 'Recommended_Badge__c', 'Badge__c'));
        objectInfoMap.put('trailheadapp__Trail__c', new ObjectInfoWrapper(trailJunctionPicklists, 'Recommended_Trail__c', 'Trail__c'));
    }

    public static void updateJunctionTypesAndLevels(List<sObject> oldRecords, Map<Id, sObject> newRecordMap, String sObjectType) {
        List<String> fieldsToCheck = new List<String>(objectInfoMap.get(sObjectType).parentJunctionPicklistMap.keySet());

        Set<Id> modifiedParentIds = new Set<Id>();

        for(sObject oldRecord : oldRecords) {
            for(String fieldToCheck : fieldsToCheck) {
                if(oldRecord.get(fieldToCheck) != newRecordMap.get(String.valueOf(oldRecord.get('Id'))).get(fieldToCheck)) {
                    modifiedParentIds.add(String.valueOf(oldRecord.get('Id')));
                }
            }
        }

        ObjectInfoWrapper parentObjectInfo = objectInfoMap.get(sObjectType);

        String queryString = 'SELECT ' + parentObjectInfo.relationshipFieldName + ', ' + String.join(fieldsToCheck, ', ') + ' FROM ' + parentObjectInfo.childJunctionObjectType +
            ' WHERE ' + parentObjectInfo.relationshipFieldName + ' IN :' + modifiedParentIds;

        List<sObject> junctionRecordsToUpdate = Database.query(queryString);

        for(sObject junctionRecord : junctionRecordsToUpdate) {
            for(String picklist : parentObjectInfo.parentJunctionPicklistMap.values()) {
                sObject parentRecord = newRecordMap.get(String.valueOf(junctionRecord.get(parentObjectInfo.relationshipFieldName)));
                junctionRecord.put(picklist, parentRecord.get(picklist));
            }
        }

        update junctionRecordsToUpdate;
    }

    private class ObjectInfoWrapper {
        Map<String, String> parentJunctionPicklistMap;
        String childJunctionObjectType;
        String relationshipFieldName;

        private ObjectInfoWrapper(Map<String, String> parentJunctionPicklistMap, String childJunctionObjectType, String relationshipFieldName) {
            this.parentJunctionPicklistMap = parentJunctionPicklistMap;
            this.childJunctionObjectType = childJunctionObjectType;
            this.relationshipFieldName = relationshipFieldName;
        }
    }
}
