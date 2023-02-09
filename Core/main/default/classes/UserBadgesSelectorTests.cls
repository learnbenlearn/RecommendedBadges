/**
 * @description       : Test class for UserBadgesSelector.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class UserBadgesSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            trailheadapp__User_Badge__c.Id
        };

        Assert.areEqual(expectedFieldList, new UserBadgesSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(trailheadapp__User_Badge__c.sObjectType, new UserBadgesSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectAll_test() {
        TestDataFactory.Badge badgeGenerator = new TestDataFactory.Badge(true, true);
        List<trailheadapp__Badge__c> testBadges = badgeGenerator.execute();

        TestDataFactory.UserBadge userBadgeGenerator = new TestDataFactory.UserBadge(true, true, testBadges);
        Map<Id, trailheadapp__User_Badge__c> expectedUserBadgesById = new Map<Id, trailheadapp__User_Badge__c>((List<trailheadapp__User_Badge__c>) userBadgeGenerator.execute());
        Map<Id, trailheadapp__User_Badge__c> resultUserBadgesById = new Map<Id, trailheadapp__User_Badge__c>(new UserBadgesSelector().selectAll());

        Assert.areEqual(expectedUserBadgesById.keySet(), resultUserBadgesById.keySet(), 'Expected all User Badges to be retrieved.');
    }
}