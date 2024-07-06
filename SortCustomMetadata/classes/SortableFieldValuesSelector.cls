/**
 * @description       : Selector class for Sortable Field Value custom metadata type.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class SortableFieldValuesSelector extends ApplicationSelector {
    /**
     * fflib method to hold the fields to always be queried by the selector
     * @return  `List<Schema.SObjectField>`
     */
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Sortable_Field_Value__mdt.MasterLabel,
            Sortable_Field_Value__mdt.Sort_Order__c
        };
    }

    /**
     * fflib method to return the sObjectType of the object being queried
     * @return  `Schema.SObjectType`
     */
    public Schema.SObjectType getSObjectType() {
        return Sortable_Field_Value__mdt.sObjectType;
    }
}