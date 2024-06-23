@isTest(IsParallel=true)
private class DMLUtils_Tests {
    @isTest
    private static void it_should_log_insert_failures() {
        Account a = new Account();

        Test.startTest();
        DMLUtils.logErrors(new List<Database.SaveResult>{Database.insert(a, false)}, 'DMLUtils_Test');
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [
            SELECT Id 
            FROM LogEntry__c 
            WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR'
        ];
        Assert.areEqual(1, loggedErrors.size(), 'Expected insert error to be logged.');
    }

    @isTest
    private static void it_should_log_update_failures() {
        Account a = new Account(Name = 'Test');
        insert a;
        a.Name = null;

        Test.startTest();
        DMLUtils.logErrors(new List<Database.SaveResult>{Database.update(a, false)}, 'DMLUtils_Test', true);
        Test.stopTest();


        List<LogEntry__c> loggedErrors = [
            SELECT Id 
            FROM LogEntry__c 
            WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR' AND RecordId__c = :a.Id
        ];
        Assert.areEqual(1, loggedErrors.size(), 'Expected update error to be logged.');
    }

    @isTest
    private static void it_should_log_delete_failures() {
        Account a = new Account(Id = Account.getSObjectType().getDescribe().getKeyPrefix().rightPad(15, '0'));

        Test.startTest();
        DMLUtils.logErrors(new List<Database.DeleteResult>{Database.delete(a, false)}, 'DMLUtils_Test');
        Test.stopTest();

        List<LogEntry__c> loggedErrors = [
            SELECT Id
            FROM LogEntry__c
            WHERE ApexClassName__c = 'DMLUtils' AND ApexMethodName__c = 'logErrors' AND LoggingLevel__c = 'ERROR' AND RecordId__c = :a.Id
        ];
        Assert.areEqual(1, loggedErrors.size(), 'Expected delete error to be logged.');
    }

    @isTest
    private static void it_should_not_log_when_all_inserts_are_successes() {
        Account a = new Account(Name = 'Test');
        
        Test.startTest();
        DMLUtils.logErrors(new List<Database.SaveResult>{Database.insert(a, false)}, 'DMLUtils_Test');
        Test.stopTest();

        List<LogEntry__c> logEntries = [SELECT Id FROM LogEntry__c];
        Assert.areEqual(0, logEntries.size(), 'Did not expect logs when all inserts are successful.');
    }

    @isTest
    private static void it_should_not_log_when_all_updates_are_successes() {
        Account a = new Account(Name = 'Test');
        insert a;
        a.NumberOfEmployees = 1;

        Test.startTest();
        DMLUtils.logErrors(new List<Database.SaveResult>{Database.update(a, false)}, 'DMLUtils_Test');
        Test.stopTest();

        List<LogEntry__c> logEntries = [SELECT Id FROM LogEntry__c];
        Assert.areEqual(0, logEntries.size(), 'Did not expect logs when all updates are successful.');
    }

    @isTest
    private static void it_should_not_log_when_all_deletes_are_successes() {
        Account a = new Account(Name = 'Test');
        insert a;

        Test.startTest();
        DMLUtils.logErrors(new List<Database.DeleteResult>{Database.delete(a, false)}, 'DMLUtils_Test');
        Test.stopTest();

        List<LogEntry__c> logEntries = [SELECT Id FROM LogEntry__c];
        Assert.areEqual(0, logEntries.size(), 'Did not expect logs when all deletes are successful.');
    }
}