/**
 * @description       : Selector class for Scratch Org Info standard object.
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class ScratchOrgInfosSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return Application.IS_DEV_HUB_ORG ? 
            new List<Schema.SObjectField>{Schema.describeSObjects(new List<String>{'ScratchOrgInfo'})[0].fields.getMap().get('Id')} :
            null;
    }

    public Schema.SObjectType getSObjectType() {
        return Application.IS_DEV_HUB_ORG ? Schema.describeSObjects(new List<String>{'ScratchOrgInfo'})[0].getSObjectType() : null;
    }

    public List<sObject> selectAllNotActive() {
        return Database.query(
            newQueryFactory().
                setCondition('Status != \'Active\'').
                toSOQL()
        );
    }
}