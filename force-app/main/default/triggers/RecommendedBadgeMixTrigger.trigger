/**
 * @description       : Trigger on the Recommended_Badge_Mix__c object to ensure that only one
 *                      Recommended_Badge_Mix__c record is marked as the default.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-25-2022
 * @last modified by  : Ben Learn
**/
trigger RecommendedBadgeMixTrigger on Recommended_Badge_Mix__c (before insert, before update) {
    switch on Trigger.operationType {
        when BEFORE_INSERT, BEFORE_UPDATE {
            RecommendedBadgeMixTrigger_Helper.enforceSingleDefaultMix(Trigger.new);
        }
    }
}