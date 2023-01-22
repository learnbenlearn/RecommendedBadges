/**
 * @description       : Test class for SortableFieldValuesSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class SortableFieldValuesSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            Sortable_Field_Value__mdt.MasterLabel,
            Sortable_Field_Value__mdt.Sort_Order__c
        };

        Assert.areEqual(expectedFieldList, new SortableFieldValuesSelector().getSObjectFieldList(), TestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(Sortable_Field_Value__mdt.sObjectType, new SortableFieldValuesSelector().getSObjectType(), TestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }
}