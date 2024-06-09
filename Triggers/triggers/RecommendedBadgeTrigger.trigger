trigger RecommendedBadgeTrigger on Recommended_Badge__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    new RecommendedBadgeTriggerHandler().execute();
}