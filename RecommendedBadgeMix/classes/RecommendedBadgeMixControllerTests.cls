@isTest(IsParallel=true)
private class RecommendedBadgeMixControllerTests {
    private static Map<String, List<Mix_Category__c>> generateData(Boolean includeDefaultMix){
        RecommendedBadgeMixTS badgeMixGenerator;
        List<Recommended_Badge_Mix__c> badgeMixes;
        if(includeDefaultMix) {
            badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{
                'generateRecordIDs' => false,
                'generatorReturnValue' => 'all',
                'numberToGenerate' => 9
            });
            badgeMixGenerator.generate();
            badgeMixGenerator.numberToGenerate = 1;
            badgeMixGenerator.setFieldSpec(new TestSupport.TestDataField(Recommended_Badge_Mix__c.Default_Badge_Mix__c, true));
        } else {
            badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 10});
        }
        badgeMixes = (List<Recommended_Badge_Mix__c>) badgeMixGenerator.generate();
        insert badgeMixes;

        Map<Id, Recommended_Badge_Mix__c> badgeMixesById = new Map<Id, Recommended_Badge_Mix__c>(badgeMixes);
        
        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 4},
            new List<TestSupport.TestDataField>{new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, Recommended_Badge_Mix__c>(badgeMixes)).keySet())}
        );
        List<Mix_Category__c> mixCategories = (List<Mix_Category__c>) mixCategoryGenerator.generate();
        insert mixCategories;

        Map<String, List<Mix_Category__c>> testCategoriesByMix = new Map<String, List<Mix_Category__c>>();
        String recommendedBadgeMixName;
        Boolean privateRecommendedBadgeMix;

        for(Mix_Category__c mc : mixCategories) {
            recommendedBadgeMixName = badgeMixesById.get(mc.Recommended_Badge_Mix__c).Name;
            privateRecommendedBadgeMix = badgeMixesById.get(mc.Recommended_Badge_Mix__c).Private_Mix__c;

            if(testCategoriesByMix.get(recommendedBadgeMixName) == null && !privateRecommendedBadgeMix) {
                testCategoriesByMix.put(recommendedBadgeMixName, new List<Mix_Category__c>{mc});
            } else if(!privateRecommendedBadgeMix) {
                List<Mix_Category__c> currentMixCategories = testCategoriesByMix.get(recommendedBadgeMixName);
                currentMixCategories.add(mc);
                testCategoriesByMix.put(recommendedBadgeMixName, currentMixCategories);
            }
        }
        return testCategoriesByMix;
    }

    @isTest
    private static void getData_testDefaultBadgeMix() {
        Map<String, List<Mix_Category__c>> testCategoriesByMix = generateData(true);
        String defaultMixName = [SELECT Name FROM Recommended_Badge_Mix__c WHERE Default_Badge_Mix__c = true][0].Name;

        Test.startTest();
        RecommendedBadgeMixController.DataWrapper testData = RecommendedBadgeMixController.getData();
        Test.stopTest();

        for(String mix : testCategoriesByMix.keySet()) {
            for(Integer i = 0; i < testCategoriesByMix.get(mix).size(); i++) {
                Assert.areEqual(testCategoriesByMix.get(mix)[i].Id, testData.categoriesByBadgeMix.get(mix)[i].mixCategory.Id, 'Expected Mix Categories by Recommended Badge Mix name to be equal.');
            }
        }

        Assert.areEqual(
            defaultMixName, 
            testData.defaultMix,
            'Expected name of default mix.'
        );
    }

    @isTest
    private static void getData_testNoDefaultBadgeMix() {
        Map<String, List<Mix_Category__c>> testCategoriesByMix = generateData(false);
        String defaultMixName = [
            SELECT Recommended_Badge_Mix__r.Name 
            FROM Mix_Category__c 
            WHERE Recommended_Badge_Mix__r.Private_Mix__c = false ORDER BY Name
        ][0].Recommended_Badge_Mix__r.Name;

        Test.startTest();
        RecommendedBadgeMixController.DataWrapper testData = RecommendedBadgeMixController.getData();
        Test.stopTest();

        for(String mix : testCategoriesByMix.keySet()) {
            for(Integer i = 0; i < testCategoriesByMix.get(mix).size(); i++) {
                Assert.areEqual(testCategoriesByMix.get(mix)[i].Id, testData.categoriesByBadgeMix.get(mix)[i].mixCategory.Id, 'Expected Mix Categories by Recommended Badge Mix name to be equal.');
            }
        }

        Assert.areEqual(
            defaultMixName, 
            testData.defaultMix,
            'Expected name of default mix.'
        );
    }
}
