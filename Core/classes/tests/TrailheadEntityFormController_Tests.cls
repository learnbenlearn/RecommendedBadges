@isTest(IsParallel=true)
private class TrailheadEntityFormController_Tests {
    @testSetup
    private static void setupMetadata() {
        TrailheadEntityFormController.providerSObjectsByChildEntityType = new Map<String, String>{
            'Recommended_Badge__c' => 'trailheadapp__Badge__c',
            'Recommended_Trail__c' => 'trailheadapp__Trail__c'
        };
    }

    @isTest
    private static void it_should_get_badges_by_api_name() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('badgesByAPINameResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        List<TrailheadEntityFormController.LookupItem> lookupItems = TrailheadEntityFormController.getTrailheadEntitiesByAPIName('Recommended_Badge__c');
        Test.stopTest();

        for(TrailheadEntityFormController.LookupItem lookupItem : lookupItems) {
            Assert.isTrue(lookupItem.Id == lookupItem.SecondaryFieldValue, 'Expected Id and SecondaryFieldValue to equal each other.');
            Assert.isNotNull(lookupItem.Id, 'Expected lookup item Id to be populated.');
            Assert.isNotNull(lookupItem.Name, 'Expected lookup item Id to be populated.');
            Assert.isNotNull(lookupItem.SecondaryFieldValue, 'Expected lookup item Id to be populated.');
        }
    }

    @isTest
    private static void it_should_get_trails_by_api_name() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('trailsByAPINameResponse');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        List<TrailheadEntityFormController.LookupItem> lookupItems = TrailheadEntityFormController.getTrailheadEntitiesByAPIName('Recommended_Badge__c');
        Test.stopTest();

        for(TrailheadEntityFormController.LookupItem lookupItem : lookupItems) {
            Assert.isTrue(lookupItem.Id == lookupItem.SecondaryFieldValue, 'Expected Id and SecondaryFieldValue to equal each other.');
            Assert.isNotNull(lookupItem.Id, 'Expected lookup item Id to be populated.');
            Assert.isNotNull(lookupItem.Name, 'Expected lookup item Id to be populated.');
            Assert.isNotNull(lookupItem.SecondaryFieldValue, 'Expected lookup item Id to be populated.');
        }
    }

    @isTest
    private static void it_should_return_null_on_initial_wire_call() {
        Assert.isNull(
            TrailheadEntityFormController.getTrailheadEntitiesByAPIName(null),
            'Expected getTrailheadEntitiesByAPIName() to return null when provided a null parameter.'
        );
    }

    @isTest
    private static void it_should_throw_an_exception_when_request_fails() {
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock('test response', 500));
        Test.startTest();
        try {
            TrailheadEntityFormController.getTrailheadEntitiesByAPIName('Recommended_Badge__c');
            Assert.fail();
        } catch(Exception e) {
            Assert.areEqual('System.AuraHandledException', e.getTypeName(), 'Expected AuraHandledException when request fails.');
        }
        Test.stopTest();
    }
    
    @isTest
    private static void it_should_return_null_when_called_with_unsupported_object() {
        Assert.isNull(
            TrailheadEntityFormController.getTrailheadEntitiesByAPIName('Account'), 
            'Expected null return value when getTrailheadEntitiesByAPIName is called with an unsupported object.'
        );
    }
}