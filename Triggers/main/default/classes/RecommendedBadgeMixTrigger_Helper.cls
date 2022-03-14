/**
 * @description       : Trigger helper class to ensure that only one Recommended_Badge_Mix__c
 *                      record is marked as the default.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-25-2022
 * @last modified by  : Ben Learn
**/
public without sharing class RecommendedBadgeMixTrigger_Helper {
    public static void enforceSingleDefaultMix(List<Recommended_Badge_Mix__c> upsertedBadgeMixes) {
        Id defaultMixId;
        
        for(Recommended_Badge_Mix__c rbm : upsertedBadgeMixes) {
            if(rbm.Default_Badge_Mix__c && (defaultMixId == null)) {
                defaultMixId = rbm.Id;
            } else if(rbm.Default_Badge_Mix__c) {
                throw new MultipleDefaultBadgeMixException('Only one recommended badge mix can be' +
                    ' marked as the default.');
            }
        }
    }
}