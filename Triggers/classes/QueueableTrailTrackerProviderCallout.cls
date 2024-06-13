/**
 * Queueable Apex job to make callouts to Trail Tracker Provider org to retrieve values for new Recommended Badge/Recommended Trail records from the corresponding fields on 
 * the related Badge/Trail records.
 * @author Ben Learn
 * @since 06-10-2024
 */
public with sharing class QueueableTrailTrackerProviderCallout implements Queueable, Database.AllowsCallouts {
    private final Id RECORD_ID;
    private final String SOBJECT_API_NAME;
    private final Map<String, String> PROVIDER_SOBJECTS_BY_OBJECT_API_NAME {
        get {
            if(this.PROVIDER_SOBJECTS_BY_OBJECT_API_NAME == null) {
                this.PROVIDER_SOBJECTS_BY_OBJECT_API_NAME = new Map<String, String>();
                List<TrailTrackerProviderObjectMapping__mdt> objectMappings = [
                    SELECT MasterLabel, RecommendedBadgesObject__r.QualifiedAPIName
                    FROM TrailTrackerProviderObjectMapping__mdt
                ];
                for(TrailTrackerProviderObjectMapping__mdt objectMapping : objectMappings) {
                    this.PROVIDER_SOBJECTS_BY_OBJECT_API_NAME.put(objectMapping.RecommendedBadgesObject__r.QualifiedAPIName, objectMapping.MasterLabel);
                }
            }
            return this.PROVIDER_SOBJECTS_BY_OBJECT_API_NAME;
        }
        set;
    }

    private final Map<String, String> PROVIDER_TO_RECOMMENDED_BADGES_FIELD_MAP {
        get {
            if(this.PROVIDER_TO_RECOMMENDED_BADGES_FIELD_MAP == null) {
                this.PROVIDER_TO_RECOMMENDED_BADGES_FIELD_MAP = new Map<String, String>();
                List<TrailTrackerProviderFieldMapping__mdt> fieldMappings = [
                    SELECT RecommendedBadgesField__c, ProviderField__c
                    FROM TrailTrackerProviderFieldMapping__mdt
                    WHERE 
                        TrailTrackerProviderObjectMapping__r.RecommendedBadgesObject__r.QualifiedApiName = :this.SOBJECT_API_NAME 
                        AND TrailTrackerProviderObjectMapping__r.MasterLabel = :this.PROVIDER_SOBJECTS_BY_OBJECT_API_NAME.get(this.SOBJECT_API_NAME)
                ];
                for(TrailTrackerProviderFieldMapping__mdt fieldMapping : fieldMappings) {
                    this.PROVIDER_TO_RECOMMENDED_BADGES_FIELD_MAP.put(fieldMapping.ProviderField__c, fieldMapping.RecommendedBadgesField__c);
                }
            }
            return this.PROVIDER_TO_RECOMMENDED_BADGES_FIELD_MAP;
        }
        set;
    }

    private String entityAPIName {
        get {
            if(this.entityAPIName == null) {
                switch on this.SOBJECT_API_NAME {
                    when 'Recommended_Badge__c' {
                        this.entityApiName = new RecommendedBadgesSelector().selectBadgeAPINameById(this.RECORD_ID).BadgeAPIName__c;
                    } when 'Recommended_Trail__c' {
                        this.entityApiName = new RecommendedTrailsSelector().selectTrailAPINameById(this.RECORD_ID).TrailAPIName__c;
                    }
                }
            }
            return this.entityApiName;
        } 
        set;
    }

    /**
     * Constructor to take record Id of new Recommended Badge/Trail and initialize instance variables.
     * @param recordId 
     */    
    public QueueableTrailTrackerProviderCallout(Id recordId) {
        this.RECORD_ID = recordId;
        this.SOBJECT_API_NAME = recordId.getSobjectType().getDescribe().getName();
    }

    /**
     * Makes REST API callout to Trail Tracker Provider org to get values of mapped fields on corresponding Badge/Trail record, then updates specified 
     * Recommended Badge/Recommended Trail with results.
     * @param context 
     */    
    public void execute(QueueableContext context) {
        String query = String.format(
            'SELECT Id, {0} FROM {1} WHERE trailheadapp__API_Name__c = \'' + this.entityAPIName + '\'',
            new List<Object>{
                String.join(new List<String>(PROVIDER_TO_RECOMMENDED_BADGES_FIELD_MAP.keySet()), ', '),
                this.PROVIDER_SOBJECTS_BY_OBJECT_API_NAME.get(this.SOBJECT_API_NAME)
            }
        );

        sObject recordToUpdate = this.RECORD_ID.getSObjectType().newSObject(this.RECORD_ID);
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Provider_Scratch/services/data/v60.0/query/?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
        request.setMethod('GET');
        HttpResponse response;

        try {
            response = new Http().send(request);
        } catch(Exception e) {
            Logger.error(new LogMessage('Error with callout to Trail Tracker Provider. {0}: {1}. \n{2}', e.getTypeName(), e.getMessage(), e.getStackTraceString()));
            Logger.saveLog();
            return;
        }

        if(response.getStatusCode() == 200) {
            Map<String, Object> record = getRecordFromResponseBody(response.getBody());
            Set<String> providerFields = PROVIDER_TO_RECOMMENDED_BADGES_FIELD_MAP.keySet();
            for(String field : record.keySet()) {
                if((field != 'attributes') && providerFields.contains(field) && (field != 'trailheadapp__API_Name__c')) {
                    recordToUpdate.put(this.PROVIDER_TO_RECOMMENDED_BADGES_FIELD_MAP.get(field), record.get(field));
                }
            }
        } else {
            Logger.error(new LogMessage('Error with callout to Trail Tracker Provider. {0}. {1}', response.toString(), response.getBody()));
            Logger.saveLog();
            return;
        }

        try {
            update recordToUpdate;
        } catch(Exception e) {
            Logger.error(new LogMessage('Error updating {0}. {1}: {2}. \n{3}', new List<String>{this.SOBJECT_API_NAME, e.getTypeName(), e.getMessage(), e.getStackTraceString()}));
            Logger.saveLog();
        }
    }

    private Map<String, Object> getRecordFromResponseBody(String responseBody) {
        return (Map<String, Object>) ((List<Object>) ((Map<String, Object>) JSON.deserializeUntyped(responseBody)).get('records'))[0];
    }
}