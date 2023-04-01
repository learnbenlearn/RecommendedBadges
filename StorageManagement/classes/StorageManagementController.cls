/**
 * @description       : Controller for storageManagementContainer LWC.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 01-08-2023
 * @last modified by  : Ben Learn
**/
public with sharing class StorageManagementController {
    /**
    * @description Method to manually invoke storage cleaning.
    * @author Ben Learn | 03-13-2022 
    **/
    @AuraEnabled
    public static void invokeManualClean(){
        try {
            List<String> objectsNotCleaned = StorageManagementService.clean();
            if(objectsNotCleaned?.size() > 0) {
                throw new AuraHandledException(
                    'Did not clean the following objects as you do not have sufficient permissions:' + String.join(objectsNotCleaned, ' ,') + '.'
                );
            }
        } catch(DMLException e) {
            throw new StackTraceDMLException(e);
        }
    }
}
