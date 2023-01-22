/**
 * @description       : Test class for RecommendedBadgeMixesSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class RecommendedBadgeMixesSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            Recommended_Badge_Mix__c.Id,
            Recommended_Badge_Mix__c.Name
        };

        Assert.areEqual(expectedFieldList, new RecommendedBadgeMixesSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(Recommended_Badge_Mix__c.sObjectType, new RecommendedBadgeMixesSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }
}