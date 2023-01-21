/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 01-20-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class MixCategoriesSelector extends fflib_SObjectSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {

        };
    }

    public Schema.SObjectType getSObjectType() {
        return Mix_Category__c.sObjectType;
    }
}