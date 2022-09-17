/**
 * @description       : Apex controller for storageLimits LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 09-11-2022
 * @last modified by  : Ben Learn
**/
public without sharing class StorageLimitsService {
    /**
    * @description Method to retrieve available and consumed org storage.
    * @author Ben Learn | 02-27-2022 
    * @return Map<String, String> 
    **/
    @AuraEnabled
    public static Map<String, String> getStorageLimitInfo(){
        Map<String, System.OrgLimit> orgLimitMap = OrgLimits.getMap();
        System.OrgLimit storageLimit = orgLimitMap.get('DataStorageMB');

        Map<String, String> infoValueMap = new Map<String, String>();
        infoValueMap.put('Name', storageLimit.getName());
        infoValueMap.put('Limit', String.valueOf(storageLimit.getLimit()));
        infoValueMap.put('Value', String.valueOf(storageLimit.getValue()));

        return infoValueMap;
    }
}