/**
 * @description       : Selector class for Sortable Field Value custom metadata type.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class SortableFieldValuesSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Sortable_Field_Value__mdt.MasterLabel,
            Sortable_Field_Value__mdt.Sort_Order__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Sortable_Field_Value__mdt.sObjectType;
    }
}