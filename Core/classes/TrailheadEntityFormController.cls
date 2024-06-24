/**
 * Apex controller for trailheadEntityForm LWC.
 * @author Ben Learn
 * @since 06-08-2024
 * @group Core
**/
public with sharing class TrailheadEntityFormController {
    @TestVisible
    private static Map<String, String> providerSObjectsByChildEntityType {
        get {
            if(providerSObjectsByChildEntityType == null) {
                providerSObjectsByChildEntityType = new Map<String, String>();
                List<TrailTrackerProviderObjectMapping__mdt> objectMappings = [
                    SELECT MasterLabel, RecommendedBadgesObject__r.QualifiedAPIName
                    FROM TrailTrackerProviderObjectMapping__mdt
                ];
                for(TrailTrackerProviderObjectMapping__mdt objectMapping : objectMappings) {
                    providerSObjectsByChildEntityType.put(objectMapping.RecommendedBadgesObject__r.QualifiedAPIName, objectMapping.MasterLabel);
                }
            }
            return providerSObjectsByChildEntityType;
        }
        set;
    }
    
    /**
     * Returns all the names and API names of all non-archived Badges (when childEntityType is Recommended_Badge__c) or Trails
     * (when childEntityType is Recommended_Trail__c) through a SOQL query using the standard Salesforce REST API on Trail Tracker Provider.
     * @param childEntityType 
     * @return  `Map<String, Object>`
     */
    @AuraEnabled(cacheable=true)
    public static List<LookupItem> getTrailheadEntitiesByAPIName(String childEntityType) {
        if(childEntityType != null && providerSObjectsByChildEntityType.get(childEntityType) != null) {
            String query = String.format(
                'SELECT trailheadapp__API_Name__c, Name FROM {0} WHERE trailheadapp__Archived__c = false',
                 new List<Object>{providerSObjectsByChildEntityType.get(childEntityType)}
            );
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Trail_Tracker_Provider/services/data/v60.0/query/?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
            request.setMethod('GET');
            try {
                HttpResponse response = new Http().send(request);
                if(response.getStatusCode() == 200) {
                    DataWeave.Script dwscript = new DataWeaveScriptResource.trailheadEntityFormMapping();
                    DataWeave.Result dwresult = dwscript.execute(new Map<String, Object>{'payload' => response.getBody()});
                    return (List<LookupItem>) dwresult.getValue();
                } else {
                    throw new AuraHandledException(response.toString() + '\n' + response.getBody());
                }
            } catch(Exception e) {
                throw new AuraHandledException('Error making callout to Trail Tracker Provider: ' + e.getMessage());
            }
        }
        return null;
    }

    /**
     * Wrapper class for lookup items for lookup util LWC.
     */    
    public class LookupItem {
        @AuraEnabled
        public String Id;
        @AuraEnabled
        public String Name;
        @AuraEnabled
        public String SecondaryFieldValue;
    }
}