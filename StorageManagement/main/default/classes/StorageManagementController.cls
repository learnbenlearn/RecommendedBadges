/**
 * @description       : Controller for storageManagementContainer LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 12-30-2022
 * @last modified by  : Ben Learn
**/
public with sharing class StorageManagementController {
    /**
    * @description Method to manually invoke storage cleaning.
    * @author Ben Learn | 03-13-2022 
    **/
    @AuraEnabled
    public static void invokeManualClean(){
        StorageManagementService.clean();
    }
}
