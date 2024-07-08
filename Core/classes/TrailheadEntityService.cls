
/**
 * Apex rest service to update Recommended Badges/Trails using data provided from Trail Tracker Provider.
 * @author Ben Learn
 * @since 06-13-2024
 * @group Core
 */
@RestResource(urlMapping='/TrailheadEntities/*')
global with sharing class TrailheadEntityService {
    @TestVisible
    private final static String DML_UPDATE_ERROR_MESSAGE = 'One or more Recommended Badges/Recommended Trails failed the update operation.';

    @TestVisible
    private final static String DML_DELETE_ERROR_MESSAGE = 'One or more Recommended Badges/Recommended Trails failed the delete operation.';

    /**
     * Updates Recommended Badges/Trails using data provided in PATCH call.
     * @param updatedBadgesByAPIName 
     * @param updatedTrailsByAPIName 
     */    
    @HttpPatch
    global static void doPatch(Map<String, Recommended_Badge__c> updatedBadgesByAPIName, Map<String, Recommended_Trail__c> updatedTrailsByAPIName) {
        List<Recommended_Badge__c> outdatedBadges = new RecommendedBadgesSelector().selectBadgesByAPINames(updatedBadgesByAPIName.keySet());
        List<Recommended_Badge__c> badgesToUpdate = new List<Recommended_Badge__c>();
        Recommended_Badge__c tempBadge;
        Recommended_Badge__c updatedBadge;

        for(Recommended_Badge__c badge : outdatedBadges) {
            tempBadge = new Recommended_Badge__c();
            updatedBadge = updatedBadgesByAPIName.get(badge.BadgeAPIName__c);
            for(String field : updatedBadge.getPopulatedFieldsAsMap().keySet()) {
                tempBadge.put(field, updatedBadge.get(field));
            }
            tempBadge.Id = badge.Id;
            badgesToUpdate.add(tempBadge);
        }

        List<Recommended_Trail__c> outdatedTrails = new RecommendedTrailsSelector().selectTrailsByAPINames(updatedTrailsByAPIName.keySet());
        List<Recommended_Trail__c> trailsToUpdate = new List<Recommended_Trail__c>();
        Recommended_Trail__c tempTrail;
        Recommended_Trail__c updatedTrail;

        for(Recommended_Trail__c trail : outdatedTrails) {
            tempTrail = new Recommended_Trail__c();
            updatedTrail = updatedTrailsByAPIName.get(trail.TrailAPIName__c);
            for(String field : updatedTrail.getPopulatedFieldsAsMap().keySet()) {
                tempTrail.put(field, updatedTrail.get(field));
            }
            tempTrail.Id = trail.Id;
            trailsToUpdate.add(tempTrail);
        }

        Boolean hasBadgeDMLFailures = false;
        if(badgesToUpdate.size() > 0) {
            List<Database.SaveResult> saveResults = Database.update(badgesToUpdate, false);
            hasBadgeDMLFailures = DMLUtils.logErrors(saveResults, 'TrailheadEntityService', true);
        }
        
        Boolean hasTrailDMLFailures = false;
        if(trailsToUpdate.size() > 0) {
            List<Database.SaveResult> saveResults = Database.update(trailsToUpdate, false);
            hasTrailDMLFailures = DMLUtils.logErrors(saveResults, 'TrailheadEntityService', true);
        }

        if(hasBadgeDMLFailures || hasTrailDMLFailures) {
            throw new TrailheadEntityServiceException(DML_UPDATE_ERROR_MESSAGE);
        }
    }

    /**
     * Deletes Recommended Badges/Trails that correspond to Badges/Trails with API names provided in DELETE call.
     */    
    @HttpDelete
    global static void doDelete() {
        Map<String, Set<String>> body = (Map<String, Set<String>>) JSON.deserialize(RestContext.request.requestBody.toString(), Map<String, Set<String>>.class);
        Set<String> deletedBadgeAPINames = body.get('deletedBadgeAPINames');
        Set<String> deletedTrailAPINames = body.get('deletedTrailAPINames');

        List<Recommended_Badge__c> badgesToDelete = deletedBadgeAPINames == null ? new List<Recommended_Badge__c>() : [
            SELECT Id FROM Recommended_Badge__c WHERE BadgeAPIName__c IN :deletedBadgeAPINames
        ];
        List<Recommended_Trail__c> trailsToDelete = deletedTrailAPINames == null ? new List<Recommended_Trail__c>() :[
            SELECT Id FROM Recommended_Trail__c WHERE TrailAPIName__c IN :deletedTrailAPINames
        ];
        
        Boolean hasBadgeDMLFailures = false;
        if(badgesToDelete.size() > 0) {
            List<Database.DeleteResult> deleteResults = Database.delete(badgesToDelete, false);
            hasBadgeDMLFailures = DMLUtils.logErrors(deleteResults, 'TrailheadEntityService');
        }
        
        Boolean hasTrailDMLFailures = false;
        if(trailsToDelete.size() > 0) {
            List<Database.DeleteResult> deleteResults = Database.delete(trailsToDelete, false);
            hasTrailDMLFailures = DMLUtils.logErrors(deleteResults, 'TrailheadEntityService');
        }

        if(hasBadgeDMLFailures || hasTrailDMLFailures) {
            throw new TrailheadEntityServiceException(DML_DELETE_ERROR_MESSAGE);
        }
    }

    private class TrailheadEntityServiceException extends Exception {}
}