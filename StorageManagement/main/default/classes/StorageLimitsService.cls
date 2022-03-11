/**
 * @description       : Apex controller for storageLimits LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-27-2022
 * @last modified by  : Ben Learn
**/
public without sharing class StorageLimitsService {
    @AuraEnabled(cacheable=true)
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