/**
 * @description       : Test class for RecommendedBadgeMixService.
 * @author            : Ben Learn
 * @last modified on  : 12-30-2022
 * @last modified by  : Ben Learn
**/
@isTest
private class RecommendedBadgeMixControllerTests {
    private static Map<String, List<Mix_Category__c>> generateData(Boolean includeDefaultMix){
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = new List<Recommended_Badge_Mix__c>();
        Boolean privateMix = false;
        for(Integer i = 0; i < 10; i++) {
            if(i == 0 && includeDefaultMix) {
                testRecommendedBadgeMixes.add(new Recommended_Badge_Mix__c(
                    Name='Test Mix ' + i,
                    Private_Mix__c = privateMix,
                    Default_Badge_Mix__c = true
                ));
            } else {
                testRecommendedBadgeMixes.add(new Recommended_Badge_Mix__c(
                    Name='Test Mix ' + i,
                    Private_Mix__c=privateMix
                ));
            }
            privateMix = !privateMix;
        }
        insert testRecommendedBadgeMixes;

        List<Mix_Category__c> testMixCategories = new List<Mix_Category__c>();
        for(Recommended_Badge_Mix__c rbm : testRecommendedBadgeMixes) {
            for(Integer i = 0; i < 4; i++) {
                testMixCategories.add(new Mix_Category__c(
                    Name=rbm.Name + ' Category ' + i,
                    Recommended_Badge_Mix__c=rbm.Id
                ));
            }
        }
        insert testMixCategories;

        testMixCategories = [SELECT Name, Recommended_Badge_Mix__r.Name FROM Mix_Category__c WHERE Recommended_Badge_Mix__r.Private_Mix__c = false];
        Map<String, List<Mix_Category__c>> testCategoriesByMix = new Map<String, List<Mix_Category__c>>();
        for(Mix_Category__c mc : testMixCategories) {
            if(testCategoriesByMix.get(mc.Recommended_Badge_Mix__r.Name) == null) {
                testCategoriesByMix.put(mc.Recommended_Badge_Mix__r.Name, new List<Mix_Category__c>{mc});
            } else {
                List<Mix_Category__c> currentMixCategories = testCategoriesByMix.get(mc.Recommended_Badge_Mix__r.Name);
                currentMixCategories.add(mc);
                testCategoriesByMix.put(mc.Recommended_Badge_Mix__r.Name, currentMixCategories);
            }
        }
        return testCategoriesByMix;
    }

    @isTest
    private static void getSetupData_testDefaultBadgeMix() {
        Map<String, List<Mix_Category__c>> testCategoriesByMix = generateData(true);
        String defaultMixName = [SELECT Name FROM Recommended_Badge_Mix__c WHERE Default_Badge_Mix__c = true][0].Name;

        Test.startTest();
        SetupDataWrapper testSetupData = RecommendedBadgeMixService.getSetupData();
        Test.stopTest();

        System.assert(
            testCategoriesByMix.equals(testSetupData.categoriesByMix),
            'Expected Mix Categories by Recommended Badge Mix name to be equal.'
        );
        System.assertEquals(
            defaultMixName, 
            testSetupData.defaultMix,
            'Expected name of default mix.'
        );
    }

    @isTest
    private static void getSetupData_testNoDefaultBadgeMix() {
        Map<String, List<Mix_Category__c>> testCategoriesByMix = generateData(false);
        String defaultMixName = [
            SELECT Recommended_Badge_Mix__r.Name 
            FROM Mix_Category__c 
            WHERE Recommended_Badge_Mix__r.Private_Mix__c = false ORDER BY Name
        ][0].Recommended_Badge_Mix__r.Name;

        Test.startTest();
        SetupDataWrapper testSetupData = RecommendedBadgeMixService.getSetupData();
        Test.stopTest();

        System.assert(
            testCategoriesByMix.equals(testSetupData.categoriesByMix),
            'Expected Mix Categories by Recommended Badge Mix name to be equal.'
        );
        System.assertEquals(
            defaultMixName, 
            testSetupData.defaultMix,
            'Expected default mix to be the Recommended Badge Mix related to the Mix Category that is alphabetically first by name.'
        );
    }
}
