/**
 * @description       : Trigger on the Recommended_Badge__c object to (1) copy picklist field values from parent 
 *                      trailheadapp__Badge__c record to new Recommended_Badge__c records and (2) create task to delete custom
 *                      metadata record on delete (if it exists).
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 03-11-2022
 * @last modified by  : Ben Learn
**/
trigger RecommendedBadgeTrigger on Recommended_Badge__c (before insert, after delete) {
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            BadgeTrigger_Helper.populateJunctionPicklists(Trigger.new, 'Recommended_Badge__c');
            BadgeTrigger_Helper.populateBadgeMixKeys(Trigger.new);
        }
        when BEFORE_UPDATE {
            BadgeTrigger_Helper.populateBadgeMixKeys(Trigger.new);
        }
        when AFTER_DELETE {
            BadgeTrigger_Helper.createCMTDeleteTasks(Trigger.old);
        }
    }
}