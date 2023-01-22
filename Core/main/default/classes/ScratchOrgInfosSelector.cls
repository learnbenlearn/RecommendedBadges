/**
 * @description       : Selector class for Scratch Org Info standard object.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class ScratchOrgInfosSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return System.Type.forName('ScratchOrgInfo') != null ? 
            new List<Schema.SObjectField>{Schema.describeSObjects(new List<String>{'ScratchOrgInfo'})[0].fields.getMap().get('Id')} :
            null;
    }

    public Schema.SObjectType getSObjectType() {
        return System.Type.forName('ScratchOrgInfo') != null ? Schema.describeSObjects(new List<String>{'ScratchOrgInfo'})[0].getSObjectType() : null;
    }
}