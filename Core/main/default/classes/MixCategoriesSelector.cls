/**
 * @description       : Selector class for Mix Category custom object.
 * @author            : Ben Learn
 * @last modified on  : 01-21-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing class MixCategoriesSelector extends ApplicationSelector {
    public List<Schema.SObjectField> getSObjectFieldList() {
        return new List<Schema.SObjectField> {
            Mix_Category__c.Id,
            Mix_Category__c.Name
        };
    }

    public Schema.SObjectType getSObjectType() {
        return Mix_Category__c.sObjectType;
    }
}