/**
 * @description       : Selector class for Sortable Field custom metadata type.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class SortableFieldsSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Sortable_Field__mdt.MasterLabel,
            Sortable_Field__mdt.Field_API_Name__c
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Sortable_Field__mdt.sObjectType;
    }
}