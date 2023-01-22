/**
 * @description       : Test class for ProductsToDeleteSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class ProductsToDeleteSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            Product_to_Delete__mdt.MasterLabel,
            Product_to_Delete__mdt.Badge_Product__c,
            Product_to_Delete__mdt.Trail_Product__c
        };

        Assert.areEqual(expectedFieldList, new ProductsToDeleteSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(Product_to_Delete__mdt.sObjectType, new ProductsToDeleteSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }
}