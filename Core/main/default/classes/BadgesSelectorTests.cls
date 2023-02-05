/**
 * @description       : Test class for BadgesSelector.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class BadgesSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            trailheadapp__Badge__c.Id
        };

        Assert.areEqual(expectedFieldList, new BadgesSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(trailheadapp__Badge__c.sObjectType, new BadgesSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectById_test() {
        TestDataFactory.Badge badgeGenerator = new TestDataFactory.Badge(true, true);
        Map<Id, trailheadapp__Badge__c> testBadgesById = new Map<Id, trailheadapp__Badge__c>((List<trailheadapp__Badge__c>) badgeGenerator.execute());

        Set<Id> badgeIds = new Set<Id>();
        Integer counter = 0;
        for(Id badgeId : testBadgesById.keySet()) {
            if(counter >= (testBadgesById.size()/2)) break;
            badgeIds.add(badgeId);
            counter += 1;
        }

        Map<Id, trailheadapp__Badge__c> resultBadgesById = new Map<Id, trailheadapp__Badge__c>(new BadgesSelector().selectById(badgeIds));
        Assert.areEqual(badgeIds, resultBadgesById.keySet(), 'Expected IDs of returned badges to equal prescribed set of IDs.');
    }
}