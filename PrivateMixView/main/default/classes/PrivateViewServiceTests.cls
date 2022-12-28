/**
 * @description       : 
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 12-22-2022
 * @last modified by  : Ben Learn
**/
@isTest
private class PrivateViewServiceTests {
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
        List<Mix_Category__c> mixCategoryData = PrivateViewService.getMixCategoryData();
        Test.stopTest();

        System.assert(testMixCategories.equals(mixCategoryData), 'Expected Mix Category data to equal test data.');
    }

    @isTest
    private static void getPrivateMixRecommendedBadges_test() {
        List<trailheadapp__Badge__c> testBadges = new List<trailheadapp__Badge__c>();
        List<trailheadapp__Trail__c> testTrails = new List<trailheadapp__Trail__c>();

        for(Integer i = 0; i < 200; i++) {
            testBadges.add(new trailheadapp__Badge__c(
                Name='Test Badge ' + i,
                trailheadapp__Level__c=getRandomLevel(),
                trailheadapp__Type__c=getRandomType(),
                trailheadapp__API_Name__c='Test_Badge_' + i,
                trailheadapp__Description__c='Test Description',
                trailheadapp__Namespace__c='Test Namespace',
                trailheadapp__URL__c='www.test.com',
                trailheadapp__Icon__c='www.testicon.com'
            ));

            testTrails.add(new trailheadapp__Trail__c(
                Name='Test Trail ' + i,
                trailheadapp__Level__c=getRandomLevel(),
                trailheadapp__API_Name__c='Test_Trail_' + i,
                trailheadapp__Description__c='Test Description',
                trailheadapp__Namespace__c='Test Namespace',
                trailheadapp__URL__c='www.test.com',
                trailheadapp__Icon__c='www.testicon.com'
            ));
        }
        insert testBadges;
        insert testTrails;

        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = new List<Recommended_Badge_Mix__c>{
            new Recommended_Badge_Mix__c(
                Name='Test Private Recommended Badge Mix',
                Private_Mix__c=true
            ),
            new Recommended_Badge_Mix__c(
                Name='Test Public Recommended Badge Mix'
            )
        };
        insert testRecommendedBadgeMixes;

        List<Mix_Category__c> testMixCategories = new List<Mix_Category__c>();
        for(Integer i = 0; i < 20; i++) {
            testMixCategories.add(new Mix_Category__c(
                Name='Test Mix Category ' + i,
                Recommended_Badge_Mix__c=testRecommendedBadgeMixes[Math.mod(i, 2)].Id
            ));
        }
        insert testMixCategories;

        List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();
        for(Integer i = 0; i < 200; i++) {
            if(Math.mod(i, 10) == 0) {
                testRecommendedBadges.add(new Recommended_Badge__c(
                    Mix_Category__c=testMixCategories[Integer.valueOf(Math.floor(i/10))].Id,
                    Badge__c=testBadges[i].Id,
                    High_Priority__c=true
                ));
            } else {
                testRecommendedBadges.add(new Recommended_Badge__c(
                    Mix_Category__c=testMixCategories[Integer.valueOf(Math.floor(i/10))].Id,
                    Badge__c=testBadges[i].Id
                ));
            }
        }
        insert testRecommendedBadges;

        List<Recommended_Badge__c> resultRecommendedBadges = [
            SELECT Badge_Name__c, High_Priority__c, High_Priority_Id__c, Level__c, Time_Estimate_Minutes__c, Time_Estimate__c, Type__c, URL__c, Mix_Category__r.Name 
            FROM Recommended_Badge__c 
            WHERE Mix_Category__r.Recommended_Badge_Mix__r.Private_Mix__c = true ORDER BY Badge_Name__c
        ];

        Map<String, List<Recommended_Badge__c>> resultRecommendedBadgeMap = new Map<String, List<Recommended_Badge__c>>();
        resultRecommendedBadgeMap.put('High Priority', new List<Recommended_Badge__c>());
        for(Recommended_Badge__c rb : resultRecommendedBadges) {
            if(rb.High_Priority__c) {
                List<Recommended_Badge__c> currentRecommendedBadges = resultRecommendedBadgeMap.get('High Priority');
                currentRecommendedBadges.add(rb);
                resultRecommendedBadgeMap.put('High Priority', currentRecommendedBadges);
            }

            if(resultRecommendedBadgeMap.get(rb.Mix_Category__r.Name) != null) {
                List<Recommended_Badge__c> currentRecommendedBadges = resultRecommendedBadgeMap.get(rb.Mix_Category__r.Name);
                currentRecommendedBadges.add(rb);
                resultRecommendedBadgeMap.put(rb.Mix_Category__r.Name, currentRecommendedBadges);
            } else {
                resultRecommendedBadgeMap.put(rb.Mix_Category__r.Name, new List<Recommended_Badge__c>{rb});
            }
        }

        Test.startTest();
        Map<String, List<Recommended_Badge__c>> privateViewMap = PrivateViewService.getPrivateMixRecommendedBadges();
        Test.stopTest();

        System.assert(resultRecommendedBadgeMap.equals(privateViewMap), 'Expected private view Recommended Badges to equal test data.');
    }
}
