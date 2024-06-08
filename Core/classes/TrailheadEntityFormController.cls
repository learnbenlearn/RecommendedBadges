/**
 * Apex controller for trailheadEntityForm LWC.
 * @author Ben Learn
 * @since 06-08-2024
 * @group Core
**/
public with sharing class TrailheadEntityFormController {
    /**
     * Returns all the names and API names of all non-archived Badges (when childEntityType is Recommended_Badge__c) or Trails
     * (when childEntityType is Recommended_Trail__c) through a SOQL query using the standard Salesforce REST API on Trail Tracker Provider.
     * @param childEntityType 
     * @return  `Map<String, Object>`
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getTrailheadEntitiesByAPIName(String childEntityType) {
        if(childEntityType != null) {
            String query = 'SELECT trailheadapp__API_Name__c, Name FROM trailheadapp__';
            switch on (childEntityType) {
                when 'Recommended_Badge__c' {
                    query += 'Badge__c';
                } when 'Recommended_Trail__c' {
                    query += 'Trail__c';
                }
            }
            query += ' WHERE trailheadapp__Archived__c = false';
            HttpRequest request = new HttpRequest();
            request.setEndpoint('callout:Provider_Scratch/services/data/v60.0/query/?q=' + EncodingUtil.urlEncode(query, 'UTF-8'));
            request.setMethod('GET');
            HttpResponse response = new Http().send(request);
            return (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        }
        return null;
    }
}