trigger RecommendedTrailTrigger on Recommended_Trail__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    new RecommendedTrailTriggerHandler().execute();
}