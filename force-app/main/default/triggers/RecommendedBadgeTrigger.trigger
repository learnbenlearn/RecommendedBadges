/**
 * @description       : Trigger on the Recommended_Badge__c object to copy picklist field values from parent trailheadapp__Badge__c record
 *                      to new Recommended_Badge__c records.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-25-2022
 * @last modified by  : Ben Learn
**/
trigger RecommendedBadgeTrigger on Recommended_Badge__c (before insert) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            BadgeTrigger_Helper.populateJunctionPicklists(Trigger.new, 'Recommended_Badge__c');
        }
    }
}