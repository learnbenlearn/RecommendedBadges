
/**
 * Apex rest service to update Recommended Badges/Trails using data provided from Trail Tracker Provider.
 * @author Ben Learn
 * @since 06-13-2024
 */
@RestResource(urlMapping='/TrailheadEntities/*')
global with sharing class TrailheadEntityService {
    @TestVisible
    private final static String DML_ERROR_MESSAGE = 'One or more Recommended Badges/Recommended Trails failed the update operation.';

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

        Boolean hasDMLFailures = false;
        if(badgesToUpdate.size() > 0) {
            List<Database.SaveResult> saveResults = Database.update(badgesToUpdate, false);
            hasDMLFailures = DMLUtils.logErrors(saveResults, 'TrailheadEntityService', true);
        }
        
        if(trailsToUpdate.size() > 0) {
            List<Database.SaveResult> saveResults = Database.update(trailsToUpdate, false);
            hasDMLFailures = DMLUtils.logErrors(saveResults, 'TrailheadEntityService', true);
        }

        if(hasDMLFailures) {
            throw new TrailheadEntityServiceException(DML_ERROR_MESSAGE);
        }
    }

    private class TrailheadEntityServiceException extends Exception {}
}