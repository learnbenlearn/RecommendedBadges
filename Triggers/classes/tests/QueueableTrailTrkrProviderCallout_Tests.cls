@isTest
private class QueueableTrailTrkrProviderCallout_Tests {
    @testSetup
    private static void generateData() {
        RecommendedBadgeMixTS badgeMixGenerator = new RecommendedBadgeMixTS(new Map<String, Object>{'generateRecordIDs' => false, 'numberToGenerate' => 1});
        insert badgeMixGenerator.generate();

        MixCategoryTS mixCategoryGenerator = new MixCategoryTS(
            new Map<String, Object>{'generateMasterRecords' => false, 'generateRecordIDs' => false, 'numberToGenerate' => 1},
            new List<TestSupport.TestDataField>{new TestSupport.TestDataField(Mix_Category__c.Recommended_Badge_Mix__c, badgeMixGenerator.records[0].Id)}  
        );
        insert mixCategoryGenerator.generate();

        RecommendedBadgeTS badgeGenerator = new RecommendedBadgeTS(
            new Map<String, Object>{'generateMasterRecords' => false, 'generateRecordIDs' => false, 'generatorReturnValue' => 'all', 'numberToGenerate' => 1},
            new List<TestSupport.TestDataField>{
				new TestSupport.TestDataField(Recommended_Badge__c.Level__c, 'Beginner'),
				new TestSupport.TestDataField(Recommended_Badge__c.Mix_Category__c, mixCategoryGenerator.records[0].Id)
			}
        );
        badgeGenerator.generate();
        badgeGenerator.setFieldSpec(new TestSupport.TestDataField(Recommended_Badge__c.BadgeName__c, 'Test Superbadge Unit')).generate();
        badgeGenerator.setFieldSpec(new TestSupport.TestDataField(Recommended_Badge__c.BadgeName__c, 'Test Superbadge')).generate();
        badgeGenerator.setFieldSpec(new TestSupport.TestDataField(Recommended_Badge__c.BadgeName__c, 'Test Specialist')).generate();
        insert badgeGenerator.setFieldSpec(new TestSupport.TestDataField(Recommended_Badge__c.BadgeName__c, 'Test Super Set')).generate();

		RecommendedTrailTS trailGenerator = new RecommendedTrailTS(
			new Map<String, Object>{'generateMasterRecords' => false, 'generateRecordIDs' => false, 'numberToGenerate' => 1},
			new List<TestSupport.TestDataField>{
				new TestSupport.TestDataField(Recommended_Trail__c.Level__c, 'Beginner'),
				new TestSupport.TestDataField(Recommended_Trail__c.Mix_Category__c, mixCategoryGenerator.records[0].Id)
			}
		);
		insert trailGenerator.generate();
    }

    @isTest
    private static void it_should_update_badge_on_successful_callout() {
        String badgeId = [SELECT Id FROM Recommended_Badge__c WHERE BadgeName__c LIKE 'Test Badge%'].Id;
        String responseBody = '{"records":[{"Id":"a00DE00000VwgwbYAB","trailheadapp__Level__c":"Intermediate","trailheadapp__API_Name__c":"Test_Badge_1"}]}';
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock(responseBody, 200));

        Test.startTest();
        System.enqueueJob(new QueueableTrailTrackerProviderCallout(badgeId));
        Test.stopTest();

        List<Recommended_Badge__c> testBadges = [SELECT Id FROM Recommended_Badge__c WHERE Id = :badgeId AND Level__c = 'Intermediate'];
        Assert.areEqual(1, testBadges.size(), 'Expected badge to be updated with data from Trail Tracker Provider response.');
    }

    @isTest
    private static void it_should_update_superbadge_unit_on_successful_callout() {
        String badgeId = [SELECT Id FROM Recommended_Badge__c WHERE BadgeName__c = 'Test Superbadge Unit'].Id;
        String responseBody = '{"records":[{"Id":"a00DE00000VwgwbYAB","trailheadapp__Level__c":null,"Name":"Test Superbadge Unit","trailheadapp__API_Name__c":"Test_Badge_2"}]}';
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock(responseBody, 200));

        Test.startTest();
        System.enqueueJob(new QueueableTrailTrackerProviderCallout(badgeId));
        Test.stopTest();

        List<Recommended_Badge__c> testBadges = [SELECT Id FROM Recommended_Badge__c WHERE Id = :badgeId AND Level__c = 'Superbadge Unit'];
        Assert.areEqual(1, testBadges.size(), 'Expected superbadge unit to be updated with data from Trail Tracker Provider response.');
    }

    @isTest
    private static void it_should_update_superbadge_on_successful_callout() {
        String badgeId = [SELECT Id FROM Recommended_Badge__c WHERE BadgeName__c = 'Test Superbadge'].Id;
        String responseBody = '{"records":[{"Id":"a00DE00000VwgwbYAB","trailheadapp__Level__c":null,"Name":"Test Superbadge","trailheadapp__API_Name__c":"Test_Badge_3"}]}';
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock(responseBody, 200));

        Test.startTest();
        System.enqueueJob(new QueueableTrailTrackerProviderCallout(badgeId));
        Test.stopTest();

        List<Recommended_Badge__c> testBadges = [SELECT Id FROM Recommended_Badge__c WHERE Id = :badgeId AND Level__c = 'Superbadge'];
        Assert.areEqual(1, testBadges.size(), 'Expected superbadge to be updated with data from Trail Tracker Provider response.');
    }

    @isTest
    private static void it_should_update_super_set_on_successful_callout() {
        String badgeId = [SELECT Id FROM Recommended_Badge__c WHERE BadgeName__c = 'Test Super Set'].Id;
        String responseBody = '{"records":[{"Id":"a00DE00000VwgwbYAB","trailheadapp__Level__c":null,"Name":"Test Super Set","trailheadapp__API_Name__c":"Test_Badge_3"}]}';
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock(responseBody, 200));

        Test.startTest();
        System.enqueueJob(new QueueableTrailTrackerProviderCallout(badgeId));
        Test.stopTest();

        List<Recommended_Badge__c> testBadges = [SELECT Id FROM Recommended_Badge__c WHERE Id = :badgeId AND Level__c = 'Super Set'];
        Assert.areEqual(1, testBadges.size(), 'Expected super set to be updated with data from Trail Tracker Provider response.');
    }

	@isTest
	private static void it_should_update_trail_on_successful_callout() {
        String trailId = [SELECT Id FROM Recommended_Trail__c].Id;
        String responseBody = '{"records":[{"Id":"a00DE00000VwgwbYAB","trailheadapp__Level__c":"Intermediate","trailheadapp__API_Name__c":"Test_Trail_1"}]}';
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock(responseBody, 200));

        Test.startTest();
        System.enqueueJob(new QueueableTrailTrackerProviderCallout(trailId));
        Test.stopTest();

        List<Recommended_Trail__c> testBadges = [SELECT Id FROM Recommended_Trail__c WHERE Id = :trailId AND Level__c = 'Intermediate'];
        Assert.areEqual(1, testBadges.size(), 'Expected badge to be updated with data from Trail Tracker Provider response.');
	}

    @isTest
    private static void it_should_log_request_failures() {
		String badgeId = [SELECT Id FROM Recommended_Badge__c][0].Id;
		Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock('', 500));

		Test.startTest();
		System.enqueueJob(new QueueableTrailTrackerProviderCallout(badgeId));
		Test.stopTest();

		List<LogEntry__c> logEntries = [SELECT Id, Message__c FROM LogEntry__c WHERE ApexClassName__c = 'QueueableTrailTrackerProviderCallout' AND ApexMethodName__c = 'execute'];
		Assert.areEqual(1, logEntries.size(), 'Expected request failure to be logged.');
		Assert.isTrue(logEntries[0].Message__c.startsWith('Error with callout to Trail Tracker Provider.'), 'Expected request failure to be logged.');
    }

    @isTest
    private static void it_should_log_record_update_failures() {
		String trailId = [SELECT Id FROM Recommended_Trail__c].Id;
        String responseBody = '{"records":[{"Id":"a00DE00000VwgwbYAB","trailheadapp__Level__c":"Made Up Level","trailheadapp__API_Name__c":"Test_Trail_1"}]}';
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock(responseBody, 200));

        Test.startTest();
        System.enqueueJob(new QueueableTrailTrackerProviderCallout(trailId));
        Test.stopTest();

		List<LogEntry__c> logEntries = [SELECT Id, Message__c FROM LogEntry__c WHERE ApexClassName__c = 'QueueableTrailTrackerProviderCallout' AND ApexMethodName__c = 'execute'];
		Assert.areEqual(1, logEntries.size(), 'Expected record update failure to be logged.');
		Assert.isTrue(logEntries[0].Message__c.startsWith('Error updating'), 'Expected record update failure to be logged.');
    }
}