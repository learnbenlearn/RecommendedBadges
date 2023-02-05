/**
 * @description       : Test class for BadgesSelector.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class BadgesSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            trailheadapp__Badge__c.Id
        };

        Assert.areEqual(expectedFieldList, new BadgesSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(trailheadapp__Badge__c.sObjectType, new BadgesSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectById_test() {
        TestDataFactory.Badge badgeGenerator = new TestDataFactory.Badge(true, true);
        Map<Id, trailheadapp__Badge__c> testBadgesById = new Map<Id, trailheadapp__Badge__c>((List<trailheadapp__Badge__c>) badgeGenerator.execute());

        Set<Id> badgeIds = new Set<Id>();
        Integer counter = 0;
        for(Id badgeId : testBadgesById.keySet()) {
            if(counter >= (testBadgesById.size()/2)) break;
            badgeIds.add(badgeId);
            counter += 1;
        }

        Map<Id, trailheadapp__Badge__c> resultBadgesById = new Map<Id, trailheadapp__Badge__c>(new BadgesSelector().selectById(badgeIds));
        Assert.areEqual(badgeIds, resultBadgesById.keySet(), 'Expected IDs of returned badges to equal prescribed set of IDs.');
    }

    @isTest
    private static void selectAllArchivedOrInProductsToDelete_test() {
        List<Badge_to_Keep__mdt> badgesToKeep = new BadgesToKeepSelector().selectAll();
        List<String> badgesToKeepNames = new List<String>();
        for(Badge_to_Keep__mdt badgeToKeep : badgesToKeep) {
            badgesToKeepNames.add(badgeToKeep.Badge_Name__c);
        }

        List<Product_to_Delete__mdt> productsToDelete = new ProductsToDeleteSelector().selectAll();
        List<String> badgeProductsToDelete = new List<String>();
        for(Product_to_Delete__mdt productToDelete : productsToDelete) {
            if(productToDelete.Badge_Product__c) badgeProductsToDelete.add(productToDelete.MasterLabel);
        }

        TestDataFactory.Badge badgeGenerator = new TestDataFactory.Badge(true, false, true, true, true, badgeProductsToDelete, badgesToKeepNames);
        badgeGenerator.execute();

        Map<Id, trailheadapp__Badge__c> resultBadgesById = new Map<Id, trailheadapp__Badge__c>([
            SELECT Id, Name, trailheadapp__Archived__c, trailheadapp__Products__c 
            FROM trailheadapp__Badge__c 
            WHERE (trailheadapp__Products__c IN :badgeProductsToDelete AND Name NOT IN :badgesToKeepNames) OR trailheadapp__Archived__c=true
        ]);

        for(trailheadapp__Badge__c resultBadge : new BadgesSelector().selectAllArchivedOrInProductsToDelete(badgeProductsToDelete, badgesToKeepNames)) {
            Assert.isTrue(resultBadgesById.keySet().contains(resultBadge.Id),
                'Retrieved badges should either be (a) archived or (b) list products with corresponding Product to Delete records and not have a corresponding Badge to Keep record.'
            );
        }
    }
}