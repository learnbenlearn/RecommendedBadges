@isTest
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
        String testResponse = '{"test": "response"}';
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock(testResponse, 200));

        Test.startTest();
        Map<String, Object> responseBody = TrailheadEntityFormController.getTrailheadEntitiesByAPIName('Recommended_Badge__c');
        Test.stopTest();
        System.debug(responseBody);
        
        Assert.areEqual((Map<String, Object>) JSON.deserializeUntyped(testResponse), responseBody, 'Expected response body to match provided value.');
    }

    @isTest
    private static void it_should_get_trails_by_api_name() {
        String testResponse = '{"test": "response"}';
        Test.setMock(HttpCalloutMock.class, new CustomHttpCalloutMock(testResponse, 200));

        Test.startTest();
        Map<String, Object> responseBody = TrailheadEntityFormController.getTrailheadEntitiesByAPIName('Recommended_Trail__c');
        Test.stopTest();
        
        Assert.areEqual((Map<String, Object>) JSON.deserializeUntyped(testResponse), responseBody, 'Expected response body to match provided value.');
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