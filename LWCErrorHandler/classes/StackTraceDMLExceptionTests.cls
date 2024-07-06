@isTest(IsParallel=true)
private class StackTraceDMLExceptionTests {
    @isTest
    private static void stackTraceDMLException_test() {
        StackTraceDMLException stde;
        DMLException testException;
        try {
            Contact testCon = new Contact(FirstName='Test');
            insert testCon;
        } catch(DMLException e) {
            testException = e;
            stde = new StackTraceDMLException(e);
        }
        System.assertEquals(testException, stde.getCause(), 'Expected StackTraceDMLException to be caused by DMLException.');
        System.assertEquals(testException.getMessage(), stde.getMessage(), 'Expected StackTraceDMLException message to be drawn from DMLException message.');
    }
}
