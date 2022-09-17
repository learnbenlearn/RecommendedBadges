/**
 * @description       : Test class for StorageManagementService.
 * @author            : Ben Learn
 * @last modified on  : 09-11-2022
 * @last modified by  : Ben Learn
**/
@isTest
private class StorageManagementServiceTests {
    private static List<String> levels = new List<String>{
        'Beginner',
        'Intermediate',
        'Advanced'
    };

    private static List<String> types = new List<String>{
        'Module',
        'Project',
        'Superbadge'
    };

    private static String getRandomLevel() {
        return levels[Integer.valueOf(Math.floor(Math.random()*levels.size()))];
    }

    private static String getRandomType() {
        return types[Integer.valueOf(Math.floor(Math.random()*types.size()))];
    }

    @isTest
    private static void manualClean_test() {
        List<trailheadapp__Badge__c> testBadges = new List<trailheadapp__Badge__c>();
        List<trailheadapp__Trail__c> testTrails = new List<trailheadapp__Trail__c>();

        // badges with Badge_to_Keep__mdt records, should not be deleted
        List<Badge_to_Keep__mdt> badgesToKeep = [SELECT Badge_Name__c FROM Badge_to_Keep__mdt];
        for(Badge_to_Keep__mdt badgeToKeep : badgesToKeep) {
            testBadges.add(new trailheadapp__Badge__c(
                Name=badgeToKeep.Badge_Name__c,
                trailheadapp__Level__c=getRandomLevel(),
                trailheadapp__Type__c=getRandomType(),
                trailheadapp__API_Name__c=badgeToKeep.Badge_Name__c,
                trailheadapp__Description__c='Test Description',
                trailheadapp__Namespace__c='Test Namespace',
                trailheadapp__URL__c='www.test.com',
                trailheadapp__Icon__c='www.testicon.com'
            ));
        }

        // badges/trails with Badge_Product_to_Delete__mdt records, should be deleted
        List<Badge_Product_to_Delete__mdt> badgeProductsToDelete = [SELECT MasterLabel, Badge_Product__c, Trail_Product__c FROM Badge_Product_to_Delete__mdt];
        for(Badge_Product_to_Delete__mdt badgeProductToDelete : badgeProductsToDelete) {
            for(Integer i = 0; i < 20; i++) {
                if(badgeProductToDelete.Badge_Product__c) {
                    testBadges.add(new trailheadapp__Badge__c(
                        Name=badgeProductToDelete.MasterLabel + ' Badge ' + i,
                        trailheadapp__Level__c=getRandomLevel(),
                        trailheadapp__Type__c=getRandomType(),
                        trailheadapp__API_Name__c=badgeProductToDelete.MasterLabel + ' Badge ' + i,
                        trailheadapp__Description__c='Test Description',
                        trailheadapp__Namespace__c='Test Namespace',
                        trailheadapp__URL__c='www.test.com',
                        trailheadapp__Icon__c='www.testicon.com',
                        trailheadapp__Products__c=badgeProductToDelete.MasterLabel
                    ));
                }
                
                if(badgeProductToDelete.Trail_Product__c) {
                    testTrails.add(new trailheadapp__Trail__c(
                        Name=badgeProductToDelete.MasterLabel + ' Trail ' + i,
                        trailheadapp__Level__c=getRandomLevel(),
                        trailheadapp__API_Name__c=badgeProductToDelete.MasterLabel + ' Trail ' + i,
                        trailheadapp__Description__c='Test Description',
                        trailheadapp__Namespace__c='Test Namespace',
                        trailheadapp__URL__c='www.test.com',
                        trailheadapp__Icon__c='www.testicon.com',
                        trailheadapp__Products__c=badgeProductToDelete.MasterLabel
                    ));
                }
            }
        }

        // badges/trails unrelated to custom metadata. those marked archived should be deleted, those not archived should remain
        Boolean archived = false;
        for(Integer i = 0; i < 200; i++) {
            testBadges.add(new trailheadapp__Badge__c(
                Name='Test Badge ' + i,
                trailheadapp__Level__c=getRandomLevel(),
                trailheadapp__Type__c=getRandomType(),
                trailheadapp__API_Name__c='Test_Badge_' + i,
                trailheadapp__Description__c='Test Description',
                trailheadapp__Namespace__c='Test Namespace',
                trailheadapp__URL__c='www.test.com',
                trailheadapp__Icon__c='www.testicon.com',
                trailheadapp__Archived__c=archived
            ));

            testTrails.add(new trailheadapp__Trail__c(
                Name='Test Trail ' + i,
                trailheadapp__Level__c=getRandomLevel(),
                trailheadapp__API_Name__c='Test_Trail_' + i,
                trailheadapp__Description__c='Test Description',
                trailheadapp__Namespace__c='Test Namespace',
                trailheadapp__URL__c='www.test.com',
                trailheadapp__Icon__c='www.testicon.com',
                trailheadapp__Archived__c=archived
            ));

            archived = !archived;
        }

        insert testBadges;
        insert testTrails;

        List<User> users = [SELECT Id FROM User];
        List<trailheadapp__User_Badge__c> testUserBadges = new List<trailheadapp__User_Badge__c>();
        for(trailheadapp__Badge__c badge : testBadges) {
            testUserBadges.add(new trailheadapp__User_Badge__c(
                trailheadapp__Badge__c=badge.Id,
                trailheadapp__User__c=users[0].Id
            ));
        }
        insert testUserBadges;

        List<trailheadapp__Debug_Log__c> testDebugLogs = new List<trailheadapp__Debug_Log__c>();
        List<trailheadapp__Trailmix__c> testTrailmixes = new List<trailheadapp__Trailmix__c>();
        for(Integer i = 0; i < 200; i++) {
            testDebugLogs.add(new trailheadapp__Debug_Log__c(
                trailheadapp__Class__c='Test ' + i,
                trailheadapp__Datetime__c=DateTime.now(),
                trailheadapp__Message__c='Test Message ' + i,
                trailheadapp__Method__c='Test Method ' + i,
                trailheadapp__Severity__c='Test ' + i,
                trailheadapp__Transaction__c='Test Transaction ' + i
            ));

            testTrailmixes.add(new trailheadapp__Trailmix__c(
                Name='Test Trailmix ' + i,
                trailheadapp__Created_By_Profile__c='www.test.com',
                trailheadapp__External_Id__c='Test Trailmix ' + i,
                trailheadapp__Slug__c='Test_Trailmix_' + i,
                trailheadapp__URL__c='www.test.com'
            ));
        }
        insert testDebugLogs;
        insert testTrailmixes;

        Test.startTest();
        StorageManagementService.manualClean();
        Test.stopTest();

        List<trailheadapp__Badge__c> remainingBadges = [SELECT Id FROM trailheadapp__Badge__c];
        List<trailheadapp__Trail__c> remainingTrails = [SELECT Id FROM trailheadapp__Trail__c];
        
        Integer numberRemainingDebugLogs = [SELECT COUNT() FROM trailheadapp__Debug_Log__c];
        Integer numberRemainingTrailmixes = [SELECT COUNT() FROM trailheadapp__Trailmix__c];
        Integer numberRemainingUserBadges = [SELECT COUNT() FROM trailheadapp__User_Badge__c];

        System.assertEquals(
            100+badgesToKeep.size(),
            remainingBadges.size(),
            'Expected archived Badges and Badges with Badge_Product_to_Delete__mdt records to be deleted.'
        );
        System.assertEquals(
            100,
            remainingTrails.size(),
            'Expected archived Trails and Trails with Badge_Product_to_Delete__mdt records to be deleted.'
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