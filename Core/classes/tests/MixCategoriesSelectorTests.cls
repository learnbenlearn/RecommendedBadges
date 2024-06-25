/**
 * @description       : Test class for MixCategoriesSelector.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
@isTest(IsParallel=true)
private class MixCategoriesSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            Mix_Category__c.Id,
            Mix_Category__c.Name
        };

        Assert.areEqual(expectedFieldList, new MixCategoriesSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(Mix_Category__c.sObjectType, new MixCategoriesSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectByIdWithRecommendedBadgeMixNames_test() {
        TestDataFactory.RecommendedBadgeMix recommendedBadgeMixGenerator = new TestDataFactory.RecommendedBadgeMix(true, true);
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = (List<Recommended_Badge_Mix__c>) recommendedBadgeMixGenerator.execute();

        TestDataFactory.MixCategory mixCategoryGenerator = new TestDataFactory.MixCategory(true, true, testRecommendedBadgeMixes);
        List<Mix_Category__c> testMixCategories = (List<Mix_Category__c>) mixCategoryGenerator.execute();

        Set<Id> mixCategoryIdsToSelect = new Set<Id>();
        Integer counter = 0;
        for(Mix_Category__c mc : testMixCategories) {
            if(counter >= testMixCategories.size() / 2) break;
            mixCategoryIdsToSelect.add(mc.Id);
            counter += 1;
        }

        Map<Id, Mix_Category__c> resultMixCategoriesById = new Map<Id, Mix_Category__c>(
            new MixCategoriesSelector().selectByIdWithRecommendedBadgeMixNames(mixCategoryIdsToSelect)
        );

        Assert.areEqual(mixCategoryIdsToSelect, resultMixCategoriesById.keySet(), 'Expected retrieved Mix Categories to match provided IDs.');
    }

    @isTest
    private static void selectByIdWithRecommendedBadgeMixPrivateMix_test() {
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 5});
        insert badgeMixGenerator.generate();
        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object>{'generateMasterRecords' => false, 'generateRecordIDs' => false, 'numberToGenerate' => 80},
            new List<TestSupport.TestDataField>{new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, sObject>(badgeMixGenerator.records)).keySet())}
        );
        insert mixCategoryGenerator.generate();

        Map<Id, Mix_Category__c> expectedMixCategoryMap = new Map<Id, Mix_Category__c>(
            [SELECT Id, Recommended_Badge_Mix__r.Private_Mix__c FROM Mix_Category__c WHERE Id IN :mixCategoryGenerator.records]
        );

        Test.startTest();
        Map<Id, Mix_Category__c> mixCategoryMap = new Map<Id, Mix_Category__c>(
            new MixCategoriesSelector().selectByIdWithRecommendedBadgeMixPrivateMix(expectedMixCategoryMap.keySet())
        );
        Test.stopTest();

        Assert.areEqual(expectedMixCategoryMap.keySet(), mixCategoryMap.keySet(), 'Expected retrieved Mix Categories to match provided IDs.');
        for(Mix_Category__c mc : mixCategoryMap.values()) {
            Assert.areEqual(
                expectedMixCategoryMap.get(mc.Id).Recommended_Badge_Mix__r.Private_Mix__c, 
                mc.Recommended_Badge_Mix__r.Private_Mix__c, 
                'Expected private status of Recommended Badge Mix related to Mix Category to match private status of Recommended Badge Mix related to provided Mix Category ID.'
            );
        }
    }

    @isTest
    private static void selectAllWithRecommendedBadgeMixInfos_test() {
        TestDataFactory.RecommendedBadgeMix recommendedBadgeMixGenerator = new TestDataFactory.RecommendedBadgeMix(true, true);
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = (List<Recommended_Badge_Mix__c>) recommendedBadgeMixGenerator.execute();

        TestDataFactory.MixCategory mixCategoryGenerator = new TestDataFactory.MixCategory(true, true, testRecommendedBadgeMixes);
        Map<Id, Mix_Category__c> expectedMixCategoriesById = new Map<Id, Mix_Category__c>((List<Mix_Category__c>) mixCategoryGenerator.execute());
        Map<Id, Mix_Category__c> resultMixCategoriesById = new Map<Id, Mix_Category__c>(new MixCategoriesSelector().selectAllWithRecommendedBadgeMixInfos(null));
        Assert.areEqual(expectedMixCategoriesById.keySet(), resultMixCategoriesById.keySet(), 'Expected all Mix Categories to be retrieved.');
    }

    @isTest
    private static void selectRecommendedBadgesAndTrails() {
        TestDataFactory.RecommendedBadgeMix recommendedBadgeMixGenerator = new TestDataFactory.RecommendedBadgeMix(true, true);
        Map<Id, Recommended_Badge_Mix__c> testRecommendedBadgeMixesById = new Map<Id, Recommended_Badge_Mix__c>(
            (List<Recommended_Badge_Mix__c>) recommendedBadgeMixGenerator.execute()
        );

        TestDataFactory.MixCategory mixCategoryGenerator = new TestDataFactory.MixCategory(true, true, testRecommendedBadgeMixesById.values());
        List<Mix_Category__c> testMixCategories = (List<Mix_Category__c>) mixCategoryGenerator.execute();

        Set<Id> expectedMixCategoryIds = new Set<Id>();
        for(Mix_Category__c mc : testMixCategories) {
            if(!testRecommendedBadgeMixesById.get(mc.Recommended_Badge_Mix__c).Private_Mix__c) expectedMixCategoryIds.add(mc.Id);
        }
        
        Map<Id, Mix_Category__c> resultMixCategoriesById = new Map<Id, Mix_Category__c>(new MixCategoriesSelector().selectRecommendedBadgesAndTrails());
        Assert.areEqual(expectedMixCategoryIds, resultMixCategoriesById.keySet(), 'Expected all Mix Categories to be retrieved.');
    }
}