/**
 * @description       : Test class for sufficient coverage for Application class to deploy.
 * @author            : Ben Learn
 * @last modified on  : 01-08-2023
 * @last modified by  : Ben Learn
**/
@isTest(IsParallel=true)
private class ApplicationTests {
    @isTest
    private static void getVariables() {
        System.assert(Application.Service != null);
    }
}
