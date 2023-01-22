/**
 * @description       : Test class for RecommendedBadgesSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class RecommendedBadgesSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            Recommended_Badge__c.Id,
            Recommended_Badge__c.Level__c,
            Recommended_Badge__c.Type__c
        };

        Assert.areEqual(expectedFieldList, new RecommendedBadgesSelector().getSObjectFieldList(), 'Expected prescribed field list.');
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(Recommended_Badge__c.sObjectType, new RecommendedBadgesSelector().getSObjectType(), 'Expected prescribed sObjectType.');
    }
}