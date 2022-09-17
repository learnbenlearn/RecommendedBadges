/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 09-17-2022
 * @last modified by  : Ben Learn
**/
@isTest
private class BensViewServiceTests {
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
    private static void getMixCategoryData_test() {
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = new List<Recommended_Badge_Mix__c>();
        Boolean privateMix = false;
        for(Integer i = 0; i < 10; i++) {
            testRecommendedBadgeMixes.add(new Recommended_Badge_Mix__c(
                Name='Test Mix ' + i,
                Private_Mix__c=privateMix
            ));
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

        testMixCategories = [
            SELECT Name, Recommended_Badge_Mix__r.Name, Recommended_Badge_Mix__r.Private_Mix__c
            FROM Mix_Category__c
            ORDER BY Name
        ];

        Test.startTest();
        List<Mix_Category__c> mixCategoryData = BensViewService.getMixCategoryData();
        Test.stopTest();

        System.assert(testMixCategories.equals(mixCategoryData), 'Expected Mix Category data to equal test data.');
    }

    @isTest
    private static void getBensMixRecommendedBadges_test() {

    }
}
