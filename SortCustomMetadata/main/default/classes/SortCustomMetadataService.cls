/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 03-13-2022
 * @last modified by  : Ben Learn
**/
public without sharing class SortCustomMetadataService {
    @AuraEnabled(cacheable=true)
    public static List<Sort_Option__mdt> getSortOptions(String componentName) {
        return [SELECT MasterLabel, Field_API_Name__c FROM Sort_Option__mdt WHERE Sortable_LWC__r.MasterLabel = :componentName];
    }
}
