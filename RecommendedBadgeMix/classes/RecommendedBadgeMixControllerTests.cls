/**
 * @description       : Test class for RecommendedBadgeMixController.
 * @author            : Ben Learn
 * @last modified on  : 02-20-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class RecommendedBadgeMixControllerTests {
    private static Map<String, List<Mix_Category__c>> generateData(Boolean includeDefaultMix){
        TestDataFactory.RecommendedBadgeMix recommendedBadgeMixGenerator = new TestDataFactory.RecommendedBadgeMix(true, true, 10, includeDefaultMix, true);
        Map<Id, Recommended_Badge_Mix__c> testRecommendedBadgeMixesById = new Map<Id, Recommended_Badge_Mix__c>(
            (List<Recommended_Badge_Mix__c>) recommendedBadgeMixGenerator.execute()
        );
        TestDataFactory.MixCategory mixCategoryGenerator = new TestDataFactory.MixCategory(true, true, 4, testRecommendedBadgeMixesById.values());
        List<Mix_Category__c> testMixCategories = mixCategoryGenerator.execute();

        Map<String, List<Mix_Category__c>> testCategoriesByMix = new Map<String, List<Mix_Category__c>>();
        String recommendedBadgeMixName;
        Boolean privateRecommendedBadgeMix;

        for(Mix_Category__c mc : testMixCategories) {
            recommendedBadgeMixName = testRecommendedBadgeMixesById.get(mc.Recommended_Badge_Mix__c).Name;
            privateRecommendedBadgeMix = testRecommendedBadgeMixesById.get(mc.Recommended_Badge_Mix__c).Private_Mix__c;

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
        RecommendedBadgeMixWrapper testData = RecommendedBadgeMixController.getData();
        Test.stopTest();

        for(String mix : testCategoriesByMix.keySet()) {
            for(Integer i = 0; i < testCategoriesByMix.get(mix).size(); i++) {
                Assert.areEqual(testCategoriesByMix.get(mix)[i].Id, testData.categoriesByMix.get(mix)[i].Id, 'Expected Mix Categories by Recommended Badge Mix name to be equal.');
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
        RecommendedBadgeMixWrapper testData = RecommendedBadgeMixController.getData();
        Test.stopTest();

        for(String mix : testCategoriesByMix.keySet()) {
            for(Integer i = 0; i < testCategoriesByMix.get(mix).size(); i++) {
                Assert.areEqual(testCategoriesByMix.get(mix)[i].Id, testData.categoriesByMix.get(mix)[i].Id, 'Expected Mix Categories by Recommended Badge Mix name to be equal.');
            }
        }

        Assert.areEqual(
            defaultMixName, 
            testData.defaultMix,
            'Expected name of default mix.'
        );
    }
}
