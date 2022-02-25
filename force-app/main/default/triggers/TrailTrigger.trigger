/**
 * @description       : Trigger on the trailheadapp__Badge__c object to update picklist field values on children junction records.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-25-2022
 * @last modified by  : Ben Learn
**/
trigger TrailTrigger on trailheadapp__Trail__c (after update) {
    switch on Trigger.operationType {
        when AFTER_UPDATE {
            BadgeTrigger_Helper.updateJunctionTypesAndLevels(Trigger.old, Trigger.newMap, 'trailheadapp__Trail__c');
        }
    }
}
