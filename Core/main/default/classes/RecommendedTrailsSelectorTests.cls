/**
 * @description       : Test class for RecommendedTrailsSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class RecommendedTrailsSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            Recommended_Trail__c.Id,
            Recommended_Trail__c.Level__c
        };

        Assert.areEqual(expectedFieldList, new RecommendedTrailsSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(Recommended_Trail__c.sObjectType, new RecommendedTrailsSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }
}