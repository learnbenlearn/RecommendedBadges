/**
 * @description       : Test class for StorageManagementController.
 * @author            : Ben Learn
 * @last modified on  : 01-08-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class StorageManagementControllerTests {
    @isTest
    private static void testInvokeManualClean_positive() {
        Application.Service.setMock(IStorageManagementService.class, new StorageManagementServiceStub());
        StorageManagementController.invokeManualClean();
        System.assertEquals(1, StorageManagementServiceStub.timesCalled_clean, 'Expected StorageManagementService clean method to be called.');
    }

    @isTest
    private static void testInvokeManualClean_negative() {
        String exceptionType;
        String exceptionMessage;
        String exceptionCauseType;

        Application.Service.setMock(IStorageManagementService.class, new StorageManagementServiceStub());
        try {
            StorageManagementServiceStub.objectsNotCleaned = new List<String>{'Test'};
            StorageManagementController.invokeManualClean();
        } catch(Exception e) {
            exceptionType = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.assertEquals('System.AuraHandledException', exceptionType, 'Expected AuraHandledException.');
        System.assertEquals('Script-thrown exception', exceptionMessage, 'Expected AuraHandledException message.');

        String testExceptionMessage = 'Test';
        try {
            StorageManagementServiceStub.dmlExceptionMessage = testExceptionMessage;
            StorageManagementServiceStub.throwDMLException = true;
            StorageManagementController.invokeManualClean();
        } catch(Exception e) {
            exceptionType = e.getTypeName();
            exceptionMessage = e.getMessage();
            exceptionCauseType = e.getCause().getTypeName();
        }
        System.assertEquals('StackTraceDMLException', exceptionType, 'Expected StackTraceDMLException.');
        System.assertEquals(testExceptionMessage, exceptionMessage, 'Expected StackTraceDMLException with provided message.');
        System.assertEquals('System.DmlException', exceptionCauseType, 'Expected StackTraceDMLException caused by DMLException.');
    }
}
