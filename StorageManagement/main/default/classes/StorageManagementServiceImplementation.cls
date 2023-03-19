/**
 * @description       : Service class containing methods to clear storage by deleting unused badges and debug logs created by the Trail Tracker app.
 * @author            : Ben Learn
 * @last modified on  : 03-04-2023
 * @last modified by  : Ben Learn
**/
public with sharing class StorageManagementServiceImplementation implements IStorageManagementService {
    /**
    * @description Method to clean storage by removing unused badges, trails, debug logs, and trailmixes.
    * @author Ben Learn | 03-13-2022 
    **/
    public List<String> clean() {
        Savepoint savepoint = Database.setSavepoint();
        try {
            List<Badge_to_Keep__mdt> badgesToKeep = new BadgesToKeepSelector().selectAll();
    
            List<String> badgesToKeepNames = new List<String>();
    
            for(Badge_to_Keep__mdt btk : badgesToKeep) {
                badgesToKeepNames.add(btk.Badge_Name__c);
            }
    
            List<Product_to_Delete__mdt> badgeProductsToDelete = new ProductsToDeleteSelector().selectAll();
    
            Map<String, List<String>> productsToDeleteMap = new Map<String, List<String>>();
            productsToDeleteMap.put('badges', new List<String>());
            productsToDeleteMap.put('trails', new List<String>());
            List<String> tempValues;
    
            for(Product_to_Delete__mdt bptd : badgeProductsToDelete) {
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
    
            // delete and purge (in order) User Badges, Badges, Trails, Debug Logs, and Trailmixes 
            // User Badges are deleted first to avoid error that occurs when deleting records already deleted through cascading delete caused by deleted Badges
            List<Schema.DescribeSObjectResult> orderedSObjects = new List<Schema.DescribeSObjectResult>();
            Map<Schema.DescribeSObjectResult, List<sObject>> sObjectsToClean = new Map<Schema.DescribeSObjectResult, List<sObject>>();

            orderedSObjects.add(Schema.SObjectType.trailheadapp__User_Badge__c);
            sObjectsToClean.put(Schema.SObjectType.trailheadapp__User_Badge__c, new UserBadgesSelector().selectAll());

            orderedSObjects.add(Schema.SObjectType.trailheadapp__Badge__c);
            sObjectsToClean.put(
                Schema.SObjectType.trailheadapp__Badge__c,
                new BadgesSelector().selectAllArchivedOrInProductsToDelete(productsToDeleteMap.get('badges'), badgesToKeepNames)
            );

            orderedSObjects.add(Schema.SObjectType.trailheadapp__Trail__c);
            sObjectsToClean.put(
                Schema.SObjectType.trailheadapp__Trail__c,
                new TrailsSelector().selectAllArchivedOrInProductsToDelete(productsToDeleteMap.get('trails'))
            );

            orderedSObjects.add(Schema.SObjectType.trailheadapp__Debug_Log__c);
            sObjectsToClean.put(Schema.SObjectType.trailheadapp__Debug_Log__c, new DebugLogsSelector().selectAll());
            orderedSObjects.add(Schema.SObjectType.trailheadapp__Trailmix__c);
            sObjectsToClean.put(Schema.SObjectType.trailheadapp__Trailmix__c, new TrailmixesSelector().selectAll());

            List<String> objectsNotDeleted = new List<String>();
            for(Integer i = 0; i < orderedSObjects.size(); i++) {
                if(!purgeRecords(sObjectsToClean.get(orderedSObjects[i]), orderedSObjects[i])) {
                    objectsNotDeleted.add(orderedSObjects[i].getLabelPlural());
                }
            }

            return objectsNotDeleted;
        } catch(DMLException e) {
            Database.rollback(savepoint);
            throw e;
        }
    }
    
    private static Boolean purgeRecords(List<sObject> records, Schema.DescribeSObjectResult sObjectDescribe) {
        Boolean objectCleaned;
        
        try {
            if(records.size() > 0) {
                delete as user records;
                Database.emptyRecycleBin(records);
            }
            objectCleaned = true;
        } catch(Exception e) {
            System.debug(e.getTypeName());
            objectCleaned = false;
        }
        return objectCleaned;
    }
}
