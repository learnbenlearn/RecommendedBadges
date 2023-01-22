/**
 * @description       : Selector class for Product to Delete custom metadata type.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class ProductsToDeleteSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Product_to_Delete__mdt.MasterLabel,
            Product_to_Delete__mdt.Badge_Product__c,
            Product_to_Delete__mdt.Trail_Product__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Product_to_Delete__mdt.sObjectType;
    }
}