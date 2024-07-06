/**
 * Apex controller for storageLimits LWC.
 * @author Ben Learn
 * @since 12-30-2022
 * @group StorageManagement
 */
public without sharing class StorageLimitsController {
    /**
     * Method to retrieve available and consumed org storage.
     * @return  `Map<String, String>`
     */
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