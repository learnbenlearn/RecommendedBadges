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
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{
            'generateRecordIDs' => false,
            'generatorReturnValue' => 'all',
            'numberToGenerate' => 9
        });
        badgeMixGenerator.generate();
        badgeMixGenerator.numberToGenerate = 1;
        List<Recommended_Badge_Mix__c> badgeMixes = (List<Recommended_Badge_Mix__c>) badgeMixGenerator.setFieldSpec(
            new TestSupport.TestDataField(Recommended_Badge_Mix__c.Default_Badge_Mix__c, true)
        ).generate();
        insert badgeMixes;        

        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 4},
            new List<TestSupport.TestDataField>{new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, Recommended_Badge_Mix__c>(badgeMixes)).keySet())}
        );
        List<Mix_Category__c> mixCategories = (List<Mix_Category__c>) mixCategoryGenerator.generate();
        insert mixCategories;

        Set<Id> mixCategoryIdsToSelect = new Set<Id>();
        Integer counter = 0;
        for(Mix_Category__c mc : mixCategories) {
            if(counter >= mixCategories.size() / 2) break;
            mixCategoryIdsToSelect.add(mc.Id);
            counter += 1;
        }

        Map<Id, Mix_Category__c> resultMixCategoriesById = new Map<Id, Mix_Category__c>(new MixCategoriesSelector().selectByIdWithRecommendedBadgeMixNames(mixCategoryIdsToSelect));
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
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{
            'generateRecordIDs' => false,
            'generatorReturnValue' => 'all',
            'numberToGenerate' => 9
        });
        badgeMixGenerator.generate();
        badgeMixGenerator.numberToGenerate = 1;
        List<Recommended_Badge_Mix__c> badgeMixes = (List<Recommended_Badge_Mix__c>) badgeMixGenerator.setFieldSpec(
            new TestSupport.TestDataField(Recommended_Badge_Mix__c.Default_Badge_Mix__c, true)
        ).generate();
        insert badgeMixes;

        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 4},
            new List<TestSupport.TestDataField>{new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, Recommended_Badge_Mix__c>(badgeMixes)).keySet())}
        );
        List<Mix_Category__c> mixCategories = (List<Mix_Category__c>) mixCategoryGenerator.generate();
        insert mixCategories;

        Map<Id, Mix_Category__c> expectedMixCategoriesById = new Map<Id, Mix_Category__c>(mixCategories);
        Map<Id, Mix_Category__c> resultMixCategoriesById = new Map<Id, Mix_Category__c>(new MixCategoriesSelector().selectAllWithRecommendedBadgeMixInfos(null));
        Assert.areEqual(expectedMixCategoriesById.keySet(), resultMixCategoriesById.keySet(), 'Expected all Mix Categories to be retrieved.');
    }

    @isTest
    private static void selectRecommendedBadgesAndTrails() {
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{
            'generateRecordIDs' => false,
            'generatorReturnValue' => 'all',
            'numberToGenerate' => 9
        });
        badgeMixGenerator.generate();
        badgeMixGenerator.numberToGenerate = 1;
        List<Recommended_Badge_Mix__c> badgeMixes = (List<Recommended_Badge_Mix__c>) badgeMixGenerator.setFieldSpec(
            new TestSupport.TestDataField(Recommended_Badge_Mix__c.Default_Badge_Mix__c, true)
        ).generate();
        insert badgeMixes;
        Map<Id, Recommended_Badge_Mix__c> badgeMixesById = new Map<Id, Recommended_Badge_Mix__c>(badgeMixes);

        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object>{
                'generateRecordIDs' => false,
                'numberToGenerate' => 4
            },
            new List<TestSupport.TestDataField>{
                new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, badgeMixesById.keySet())
            }
        );
        List<Mix_Category__c> mixCategories = (List<Mix_Category__c>) mixCategoryGenerator.generate();
        insert mixCategories;

        Set<Id> expectedMixCategoryIds = new Set<Id>();
        for(Mix_Category__c mc : mixCategories) {
            if(!badgeMixesById.get(mc.Recommended_Badge_Mix__c).Private_Mix__c) expectedMixCategoryIds.add(mc.Id);
        }
        
        Map<Id, Mix_Category__c> resultMixCategoriesById = new Map<Id, Mix_Category__c>(new MixCategoriesSelector().selectRecommendedBadgesAndTrails());
        Assert.areEqual(expectedMixCategoryIds, resultMixCategoriesById.keySet(), 'Expected all Mix Categories to be retrieved.');
    }
}