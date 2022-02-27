/**
 * @description       : Class containing methods to clear storage by deleting unused badges and debug logs created by the Trail
 *                      Tracker app.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-27-2022
 * @last modified by  : Ben Learn
**/
public with sharing class StorageManagementService {
    @AuraEnabled
    public static void manualClean(){
        clean();
    }
    
    public static void clean() {
        List<Badge_to_Keep__mdt> badgesToKeep = [SELECT Badge_Name__c FROM Badge_to_Keep__mdt];

        List<String> badgesToKeepNames = new List<String>();

        for(Badge_to_Keep__mdt btk : badgesToKeep) {
            badgesToKeepNames.add(btk.Badge_Name__c);
        }

        List<Badge_Product_to_Delete__mdt> badgeProductsToDelete = [SELECT MasterLabel, Badge_Product__c, Trail_Product__c FROM 
            Badge_Product_to_Delete__mdt];

        Map<String, List<String>> productsToDeleteMap = new Map<String, List<String>>();
        productsToDeleteMap.put('badges', new List<String>());
        productsToDeleteMap.put('trails', new List<String>());
        List<String> tempValues;

        for(Badge_Product_to_Delete__mdt bptd : badgeProductsToDelete) {
            if(bptd.Badge_Product__c) {
                tempValues = productsToDeleteMap.get('badges');
                tempValues.add(bptd.MasterLabel);
                productsToDeleteMap.put('badges', tempValues);
            }

            if(bptd.Trail_Product__c) {
                tempValues = productsToDeleteMap.get('trails');
                tempValues.add(bptd.MasterLabel);
                productsToDeleteMap.put('trails', tempValues);
            }
        }

        List<trailheadapp__Badge__c> badgesToDelete = [SELECT Id FROM trailheadapp__Badge__c WHERE trailheadapp__Products__c 
            IN :productsToDeleteMap.get('badges') AND Name NOT IN :badgesToKeepNames];

        List<trailheadapp__Trail__c> trailsToDelete = [SELECT Id FROM trailheadapp__Trail__c WHERE trailheadapp__Products__c
            IN :productsToDeleteMap.get('trails')];
            
        List<trailheadapp__Debug_Log__c> debugLogsToDelete = [SELECT Id FROM trailheadapp__Debug_Log__c];

        delete badgesToDelete;
        delete trailsToDelete;
        delete debugLogsToDelete;

        Database.emptyRecycleBin(badgesToDelete);
        Database.emptyRecycleBin(trailsToDelete);
        Database.emptyRecycleBin(debugLogsToDelete);
    }
}
