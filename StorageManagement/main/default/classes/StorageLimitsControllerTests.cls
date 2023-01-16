/**
 * @description       : Test class for StorageLimitsController.
 * @author            : Ben Learn
 * @last modified on  : 01-08-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class StorageLimitsControllerTests {
    @isTest
    private static void getStorageLimitInfo_test() {
        Map<String, String> testInfoValueMap = StorageLimitsController.getStorageLimitInfo();

        System.assert(testInfoValueMap.containsKey('Name'), 'Expected Name key in returned map.');
        System.assert(testInfoValueMap.containsKey('Limit'), 'Expected Limit key in returned map.');
        System.assert(testInfoValueMap.containsKey('Value'), 'Expected Value key in returned map.');
    }
}