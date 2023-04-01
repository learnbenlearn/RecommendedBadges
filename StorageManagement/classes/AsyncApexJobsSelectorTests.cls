/**
 * @description       : Test class for AsyncApexJobsSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class AsyncApexJobsSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            AsyncApexJob.Id
        };

        Assert.areEqual(expectedFieldList, new AsyncApexJobsSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(AsyncApexJob.sObjectType, new AsyncApexJobsSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectCompletedJobsByMethod_test() {
        Assert.areEqual(0, new AsyncApexJobsSelector().selectCompletedJobsByMethod('startAsync').size(), 'Expected zero AsyncApexJob records.');
    }
}