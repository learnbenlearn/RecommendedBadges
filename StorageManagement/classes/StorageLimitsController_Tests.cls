@isTest
private class StorageLimitsController_Tests {
    @isTest
    private static void it_should_return_storage_limits() {
        Test.startTest();
        Map<String, String> storageLimitMap = StorageLimitsController.getStorageLimitInfo();
        Test.stopTest();

        Set<String> expectedKeys = new Set<String>{'Name', 'Limit', 'Value'};
        Assert.isTrue(storageLimitMap.keySet().containsAll(expectedKeys), 'Expected returned map to have information on storage limit and consumption.');
    }
}