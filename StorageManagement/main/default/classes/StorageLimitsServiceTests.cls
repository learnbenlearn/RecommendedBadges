/**
 * @description       : Test class for StorageLimitsService.
 * @author            : Ben Learn
 * @last modified on  : 09-11-2022
 * @last modified by  : Ben Learn
**/
@isTest
private class StorageLimitsServiceTests {
    @isTest
    private static void getStorageLimitInfo_test() {
        Map<String, String> testInfoValueMap = StorageLimitsService.getStorageLimitInfo();

        System.assertEquals(
            'DataStorageMB',
            testInfoValueMap.get('Name'),
            'Expected method to return limit for data storage.'
        );
        /*System.assertEquals(
            String.valueOf(OrgLimits.getMap().get('DataStorageMB').getLimit()),
            testInfoValueMap.get('Limit'),
            'Expected method to return limit for data storage.'
        );
        System.assertEquals(
            String.valueOf(OrgLimits.getMap().get('DataStorageMB').getValue()), 
            testInfoValueMap.get('Value'),
            'Expected method to return consumed data storage.'
        );*/
    }
}
