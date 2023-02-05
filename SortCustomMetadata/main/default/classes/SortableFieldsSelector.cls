/**
 * @description       : Selector class for Sortable Field custom metadata type.
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
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

    public List<Schema.Sortable_Field__mdt> selectByComponentNameWithSortableFieldValues(String componentName) {
        fflib_QueryFactory sortableFieldsQueryFactory = newQueryFactory();

        String relationshipName;
        List<Schema.ChildRelationship> sortableFieldsChildRelationships = Schema.SObjectType.Sortable_Field__mdt.getChildRelationships();
        for(Schema.ChildRelationship childRelationship : sortableFieldsChildRelationships) {
            if(childRelationship.getChildSObject() == Sortable_Field_Value__mdt.sObjectType) {
                relationshipName = childRelationship.getRelationshipName();
            }
        }

        fflib_QueryFactory sortableFieldValuesSubQueryFactory = new SortableFieldValuesSelector().addQueryFactorySubselect(sortableFieldsQueryFactory, relationshipName, true);
        return (List<Sortable_Field__mdt>) Database.query(sortableFieldsQueryFactory.setCondition('Sortable_LWC__r.MasterLabel = :componentName').toSOQL());
    }
}