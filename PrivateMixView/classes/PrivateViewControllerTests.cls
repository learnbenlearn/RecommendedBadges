@isTest(IsParallel=true)
private class PrivateViewControllerTests {
    @isTest
    private static void getMixCategoryData_test() {
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

        mixCategories = [
            SELECT Name, Recommended_Badge_Mix__r.Name, Recommended_Badge_Mix__r.Private_Mix__c
            FROM Mix_Category__c
            ORDER BY Name
        ];

        Test.startTest();
        List<Mix_Category__c> mixCategoryData = PrivateViewController.getMixCategoryData();
        Test.stopTest();

        System.assert(mixCategories.equals(mixCategoryData), 'Expected Mix Category data to equal test data.');
    }

    @isTest
    private static void getPrivateMixRecommendedBadges_test() {
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 2});
        List<Recommended_Badge_Mix__c> badgeMixes = (List<Recommended_Badge_Mix__c>) badgeMixGenerator.generate();
        insert badgeMixes;

        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 20},
            new List<TestSupport.TestDataField>{new RelationshipField(Mix_Category__c.Recommended_Badge_Mix__c, (new Map<Id, Recommended_Badge_Mix__c>(badgeMixes)).keySet())}
        );
        List<Mix_Category__c> mixCategories = (List<Mix_Category__c>) mixCategoryGenerator.generate();
        insert mixCategories;

        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object>{'generateRecordIDs' => false}, 
            new List<TestSupport.TestDataField>{
                new BooleanField(Recommended_Badge__c.High_Priority__c, true),
                new RelationshipField(Recommended_Badge__c.Mix_Category__c, (new Map<Id, Mix_Category__c>(mixCategories)).keySet())}
        );
        List<Recommended_Badge__c> badges = (List<Recommended_Badge__c>) badgeGenerator.generate();
        insert badges;

        List<Recommended_Badge__c> resultRecommendedBadges = [
            SELECT BadgeName__c, High_Priority__c, High_Priority_Id__c, Level__c, Time_Estimate_Minutes__c, Time_Estimate__c, Type__c, URL__c, Mix_Category__r.Name 
            FROM Recommended_Badge__c 
            WHERE Mix_Category__r.Recommended_Badge_Mix__r.Private_Mix__c = true ORDER BY BadgeName__c
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
        Map<String, List<Recommended_Badge__c>> privateViewMap = PrivateViewController.getPrivateMixRecommendedBadges();
        Test.stopTest();

        Assert.isTrue(resultRecommendedBadgeMap.keySet().equals(privateViewMap.keySet()), 'Expected private view Recommended Badges to equal test data.');
        for(String mixCategory : privateViewMap.keySet()) {
            List<Recommended_Badge__c> expectedMixCategoryBadges = resultRecommendedBadgeMap.get(mixCategory);
            for(Recommended_Badge__c badge : privateViewMap.get(mixCategory)) {
                expectedMixCategoryBadges.remove(expectedMixCategoryBadges.indexOf(badge));
            }
            Assert.areEqual(0, expectedMixCategoryBadges.size(), 'Expected private view Recommended Badges to equal test data.');
        }
    }
}
