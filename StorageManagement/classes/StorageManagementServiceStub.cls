/**
 * @description       : Stub class for storage management service layer.
 * @author            : Ben Learn
 * @last modified on  : 01-08-2023
 * @last modified by  : Ben Learn
**/
public with sharing class StorageManagementServiceStub implements IStorageManagementService {
    @testVisible
    private static Integer timesCalled_clean = 0;

    @testVisible
    private static List<String> objectsNotCleaned;

    @testVisible
    private static Boolean throwDMLException = false;

    @testVisible
    private static String dmlExceptionMessage;
    
    public List<String> clean() {
        if(throwDMLException) {
            throw new DMLException(dmlExceptionMessage);
        } else {
            timesCalled_clean += 1;
            return objectsNotCleaned;
        }
    }
}
