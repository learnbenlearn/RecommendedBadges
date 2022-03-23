/**
 * @description       : Class containing methods to clear storage by deleting unused badges and debug logs created by the Trail
 *                      Tracker app.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 03-23-2022
 * @last modified by  : Ben Learn
**/
public with sharing class StorageManagementService {
    /**
    * @description Method to manually invoke storage cleaning.
    * @author Ben Learn | 03-13-2022 
    **/
    @AuraEnabled
    public static void manualClean(){
        clean();
    }
    
    /**
    * @description Method to clean storage by removing unused badges, trails, debug logs, and trailmixes.
    * @author Ben Learn | 03-13-2022 
    **/
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

        List<trailheadapp__Badge__c> archivedBadges = [SELECT Id FROM trailheadapp__Badge__c WHERE trailheadapp__Archived__c = true];

        List<trailheadapp__Badge__c> badgesToDelete = [SELECT Id FROM trailheadapp__Badge__c WHERE trailheadapp__Products__c 
            IN :productsToDeleteMap.get('badges') AND Name NOT IN :badgesToKeepNames AND Id NOT IN :archivedBadges];

        List<trailheadapp__Trail__c> trailsToDelete = [SELECT Id FROM trailheadapp__Trail__c WHERE trailheadapp__Products__c
            IN :productsToDeleteMap.get('trails')];
            
        List<trailheadapp__Debug_Log__c> debugLogsToDelete = [SELECT Id FROM trailheadapp__Debug_Log__c];

        List<trailheadapp__Trailmix__c> trailmixesToDelete = [SELECT Id FROM trailheadapp__Trailmix__c WHERE 
            trailheadapp__Created_By_Profile__c != 'https://trailhead.salesforce.com/users/profiles/blearn5241'];

        delete archivedBadges;
        delete badgesToDelete;
        delete trailsToDelete;
        delete debugLogsToDelete;
        delete trailmixesToDelete;

        if(archivedBadges.size() > 0) Database.emptyRecycleBin(archivedBadges);
        if(badgesToDelete.size() > 0) Database.emptyRecycleBin(badgesToDelete);
        if(trailsToDelete.size() > 0) Database.emptyRecycleBin(trailsToDelete);
        if(debugLogsToDelete.size() > 0) Database.emptyRecycleBin(debugLogsToDelete);
        if(trailmixesToDelete.size() > 0) Database.emptyRecycleBin(trailmixesToDelete);
    }
}
