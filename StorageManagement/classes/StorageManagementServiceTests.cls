/**
 * @description       : Test class for StorageManagementService.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class StorageManagementServiceTests {
    private static void makeData(){
        List<Badge_to_Keep__mdt> badgesToKeep = new BadgesToKeepSelector().selectAll();
        List<String> badgesToKeepNames = new List<String>();
        for(Badge_to_Keep__mdt badgeToKeep : badgesToKeep) {
            badgesToKeepNames.add(badgeToKeep.Badge_Name__c);
        }
        List<Product_to_Delete__mdt> productsToDelete = [SELECT MasterLabel, Badge_Product__c, Trail_Product__c FROM Product_to_Delete__mdt];
        List<String> badgeProductsToDelete = new List<String>();
        List<String> trailProductsToDelete = new List<String>();
        for(Product_to_Delete__mdt productToDelete : productsToDelete) {
            if(productToDelete.Badge_Product__c) badgeProductsToDelete.add(productToDelete.MasterLabel);
            if(productToDelete.Trail_Product__c) trailProductsToDelete.add(productToDelete.MasterLabel);
        }

        TestDataFactory.Badge badgeGenerator = new TestDataFactory.Badge(true, true, true, true, true, badgeProductsToDelete, badgesToKeepNames);
        List<trailheadapp__Badge__c> testBadges = badgeGenerator.execute();

        TestDataFactory.Trail trailGenerator = new TestDataFactory.Trail(true, false, true, true, trailProductsToDelete);
        trailGenerator.execute();

        TestDataFactory.UserBadge userBadgeGenerator = new TestDataFactory.UserBadge(true, false, testBadges);
        userBadgeGenerator.execute();

        TestDataFactory.DebugLog debugLogGenerator = new TestDataFactory.DebugLog(true, false);
        debugLogGenerator.execute();

        TestDataFactory.Trailmix trailmixGenerator = new TestDataFactory.Trailmix(true, false);
        trailmixGenerator.execute();
    }

    @isTest
    private static void manualClean_test() {
        makeData();
        List<Badge_to_Keep__mdt> badgesToKeep = new BadgesToKeepSelector().selectAll();
        Test.startTest();
        StorageManagementService.clean();
        Test.stopTest();

        List<trailheadapp__Badge__c> remainingBadges = [SELECT Id FROM trailheadapp__Badge__c];
        List<trailheadapp__Trail__c> remainingTrails = [SELECT Id FROM trailheadapp__Trail__c];
        
        Integer numberRemainingDebugLogs = [SELECT COUNT() FROM trailheadapp__Debug_Log__c];
        Integer numberRemainingTrailmixes = [SELECT COUNT() FROM trailheadapp__Trailmix__c];
        Integer numberRemainingUserBadges = [SELECT COUNT() FROM trailheadapp__User_Badge__c];
        System.assertEquals(
            100+badgesToKeep.size(),
            remainingBadges.size(),
            'Expected archived Badges and Badges with Product to Delete records to be deleted. Badges with Badge to Keep records should remain.'
        );
        System.assertEquals(
            100,
            remainingTrails.size(),
            'Expected archived Trails and Trails with Product to Delete records to be deleted.'
        );
        System.assertEquals(
            0,
            numberRemainingDebugLogs,
            'Expected all Debug Logs to be deleted.'
        );
        System.assertEquals(
            0, 
            numberRemainingTrailmixes,
            'Expected all Trailmixes to be deleted.'
        );
        System.assertEquals(
            0,
            numberRemainingUserBadges, 
            'Expected all User Badges to be deleted.'
        );
    }
}