/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 08-26-2022
 * @last modified by  : Ben Learn
**/
@isTest
private class RecommendedBadgeMixTrigger_HelperTests {
    static Integer suffix = 1;

    @isTest
    static void testEnforceSingleDefaultMix_NoDefault() {
        List<Recommended_Badge_Mix__c> recommendedBadgeMixes = new List<Recommended_Badge_Mix__c>();
        recommendedBadgeMixes.add(new Recommended_Badge_Mix__c(Name='Test'));
        recommendedBadgeMixes[0].Id = generateId(recommendedBadgeMixes[0]);

        RecommendedBadgeMixTrigger_Helper.enforceSingleDefaultMix(recommendedBadgeMixes);
    }

    @isTest
    static void testEnforceSingleDefaultMix_Positive() {
        
    }

    static String generateId(sObject record) {
        String sObjectPrefix = record.getSObjectType().getDescribe().getKeyPrefix();
        String idSuffix = String.valueOf(suffix++);
        return sObjectPrefix + '0'.repeat(12 - idSuffix.length()) + idSuffix;
    }
}
