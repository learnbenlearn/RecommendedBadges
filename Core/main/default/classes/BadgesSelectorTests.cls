/**
 * @description       : Test class for BadgesSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
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
}