/**
 * @description       : Trigger on the Recommended_Trail__c object to copy picklist field values from parent trailheadapp__Trail__c record
 *                      to new Recommended_Trail__c records.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 01-29-2023
 * @last modified by  : Ben Learn
**/
trigger RecommendedTrailTrigger on Recommended_Trail__c (before insert) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            BadgeTrigger_Helper.populateJunctionPicklists(Trigger.new, Schema.SObjectType.Recommended_Trail__c.getName());
        }
    }
}