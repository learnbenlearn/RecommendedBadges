/**
 * @description       : Apex class to retrieve records of the Sortable Field custom metadata type.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 03-13-2022
 * @last modified by  : Ben Learn
**/
public without sharing class SortCustomMetadataService {
    @AuraEnabled(cacheable=true)
    public static List<Sortable_Field__mdt> getSortOptions(String componentName) {
        return [SELECT MasterLabel, Field_API_Name__c, (SELECT MasterLabel, Sort_Order__c FROM Sortable_Field_Values__r) FROM Sortable_Field__mdt WHERE Sortable_LWC__r.MasterLabel = :componentName];
    }
}
