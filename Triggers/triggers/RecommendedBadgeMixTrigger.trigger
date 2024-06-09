/**
 * @description       : Trigger on the Recommended_Badge_Mix__c object to ensure that only one
 *                      Recommended_Badge_Mix__c record is marked as the default.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 08-28-2022
 * @last modified by  : Ben Learn
**/
trigger RecommendedBadgeMixTrigger on Recommended_Badge_Mix__c (before insert, after insert, before update, after update, before delete, after delete, after undelete) {
    new RecommendedBadgeMixTriggerHandler().execute();
}