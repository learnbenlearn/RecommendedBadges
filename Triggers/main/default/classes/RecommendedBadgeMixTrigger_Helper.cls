/**
 * @description       : Trigger helper class to ensure that only one Recommended_Badge_Mix__c
 *                      record is marked as the default.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 08-28-2022
 * @last modified by  : Ben Learn
**/
public without sharing class RecommendedBadgeMixTrigger_Helper {
    /**
    * @description Method to ensure that only one recommended badge mix is marked as a default.
    * @author Ben Learn | 02-25-2022 
    * @param List<Recommended_Badge_Mix__c> upsertedBadgeMixes 
    **/
    public static void enforceSingleDefaultMix(Map<Id, Recommended_Badge_Mix__c> upsertedBadgeMixes) {
        Id defaultMixId;

        List<Id> upsertedBadgeMixIds = new List<Id>(upsertedBadgeMixes.keySet());
        Integer numExistingDefaultMixes = [SELECT COUNT() FROM Recommended_Badge_Mix__c WHERE 
            Id NOT IN :upsertedBadgeMixIds];
        
        for(Id rbmId : upsertedBadgeMixes.keySet()) {
            if(upsertedBadgeMixes.get(rbmId).Default_Badge_Mix__c) {
                if((numExistingDefaultMixes > 0) || (defaultMixId != null)) {
                    throw new MultipleDefaultBadgeMixException('Only one recommended badge mix can be marked as the default.');
                } else {
                    defaultMixId = rbmId;
                }
            }
        }
    }
}