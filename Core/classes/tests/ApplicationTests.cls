@isTest(IsParallel=true)
private class ApplicationTests {
    @isTest
    private static void getVariables() {
        System.assert(Application.Service != null);
    }
}
