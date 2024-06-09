/**
 * Trigger handler for Recommended_Badge_Mix__c custom object
 * @author Ben Learn
 * @since 01-29-2023
 * @group Triggers
**/
public without sharing class RecommendedBadgeMixTriggerHandler extends TriggerHandler {

    public RecommendedBadgeMixTriggerHandler() {
        super();
    }

    protected override void afterInsert(Map<Id, sObject> newRecordsMap) {
        enforceSingleDefaultMix((Map<Id, Recommended_Badge_Mix__c>) newRecordsMap);
    }

    protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) {
        enforceSingleDefaultMix((Map<Id, Recommended_Badge_Mix__c>) updatedRecordsMap);
    }
    
    /**
     * Validates that only one recommended badge mix is marked as a default. Throws a MultipleDefaultBadgeMixException if multiple are marked as defaults.
     * @param List<Recommended_Badge_Mix__c> upsertedBadgeMixes 
    */
    private static void enforceSingleDefaultMix(Map<Id, Recommended_Badge_Mix__c> upsertedBadgeMixes) {
        Id defaultMixId;
        List<Id> upsertedBadgeMixIds = new List<Id>(upsertedBadgeMixes.keySet());
        List<Recommended_Badge_Mix__c> existingDefaultBadgeMixes = new RecommendedBadgeMixesSelector().selectExistingDefaultMix(upsertedBadgeMixIds);
        
        for(Id rbmId : upsertedBadgeMixes.keySet()) {
            if(upsertedBadgeMixes.get(rbmId).Default_Badge_Mix__c) {
                if(existingDefaultBadgeMixes.size() > 0) {
                    throw new MultipleDefaultBadgeMixException(
                        'Only one recommended badge mix can be marked as the default. ' 
                        + existingDefaultBadgeMixes[0].Name + ' is already marked as the default badge mix.'
                    );
                } else if(defaultMixId != null) {
                    throw new MultipleDefaultBadgeMixException('Only one recommended badge mix can be marked as the default.');
                } else {
                    defaultMixId = rbmId;
                }
            }
        }
    }

    /**
     * Custom exception thrown when multiple Recommended_Badge_Mix__c records are marked default.
     */    
    public class MultipleDefaultBadgeMixException extends Exception {}
}