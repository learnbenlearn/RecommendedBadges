@isTest
private class RecommendedBadgeMixTrigger_Tests {
    private static String NO_EXCEPTION_EXPECTED_MESSAGE = 'No exception expected.';

    private static List<Recommended_Badge_Mix__c> generateTestData(Integer numberRecommendedBadgeMixes, Integer numberDefaultRecommendedBadgeMixes) {
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = new List<Recommended_Badge_Mix__c>();
        for(Integer i = 0; i < numberRecommendedBadgeMixes; i++) {
            if(i < numberDefaultRecommendedBadgeMixes) {
                testRecommendedBadgeMixes.add(new Recommended_Badge_Mix__c(Name='Test ' + i, Default_Badge_Mix__c=true));
            } else {
                testRecommendedBadgeMixes.add(new Recommended_Badge_Mix__c(Name='Test ' + i));
            }
        }
        return testRecommendedBadgeMixes;
    }

    @isTest
    private static void testEnforceSingleDefaultMix_insertNoDefault() {
        Boolean caughtException = false;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(1, 0);

        try {
            insert testRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, NO_EXCEPTION_EXPECTED_MESSAGE);
    }

    @isTest
    private static void testEnforceSingleDefaultMix_insertPositive() {
        Boolean caughtException = false;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(1, 1);

        try {
            insert testRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, NO_EXCEPTION_EXPECTED_MESSAGE);
    }

    @isTest
    private static void testEnforceSingleDefaultMix_insertNegative() {
        Boolean caughtException = false;
        String exceptionMessage;

        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(2, 2);

        try {
            insert testRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
            exceptionMessage = e.getMessage();
        }

        System.assert(caughtException, 'Expected exception.');
        System.assert(exceptionMessage.contains('Only one recommended badge mix can be marked as the default.'), 'Expected exception with provided message.');
    }

    @isTest
    private static void testEnforceSingleDefaultMix_insertBulkNoDefault() {
        Boolean caughtException = false;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(200, 0);

        try {
            insert testRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, NO_EXCEPTION_EXPECTED_MESSAGE);
    }

    @isTest
    private static void testEnforceSingleDefaultMix_insertBulkPositive() {
        Boolean caughtException = false;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(200, 1);

        try {
            insert testRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, NO_EXCEPTION_EXPECTED_MESSAGE);
    }

    @isTest
    private static void testEnforceSingleDefaultMix_insertBulkNegative() {
        Boolean caughtException = false;
        String exceptionMessage;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(200, 10);

        try {
            insert testRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
            exceptionMessage = e.getMessage();
        }

        System.assert(caughtException, 'Expected exception.');
        System.assert(exceptionMessage.contains('Only one recommended badge mix can be marked as the default.'), 'Expected exception with provided message.');
    }

    @isTest
    private static void testEnforceSingleDefaultMix_updateNoDefault() {
        Boolean caughtException = false;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(1, 0);

        try {
            insert testRecommendedBadgeMixes;
            testRecommendedBadgeMixes[0].Name += ' test';
            update testRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, NO_EXCEPTION_EXPECTED_MESSAGE);   
    }

    @isTest
    private static void testEnforceSingleDefaultMix_updatePositive() {
        Boolean caughtException = false;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(1, 1);

        try {
            insert testRecommendedBadgeMixes;
            testRecommendedBadgeMixes[0].Name += ' test';
            update testRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, NO_EXCEPTION_EXPECTED_MESSAGE);
    }

    @isTest
    private static void testEnforceSingleDefaultMix_updateNegative() {
        Boolean caughtException = false;
        String exceptionMessage;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(2, 1);

        try {
            insert testRecommendedBadgeMixes;
            testRecommendedBadgeMixes[1].Default_Badge_Mix__c = true;
            update testRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
            exceptionMessage = e.getMessage();
        }

        System.assert(caughtException, 'Expected exception.');
        System.assert(exceptionMessage.contains('Only one recommended badge mix can be marked as the default.'), 'Expected exception with provided message.');
    }

    @isTest
    private static void testEnforceSingleDefaultMix_updateNoDefaultBulk() {
        Boolean caughtException = false;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(200, 0);
        
        try {
            insert testRecommendedBadgeMixes;
            List<Recommended_Badge_Mix__c> updatedTestRecommendedBadgeMixes = new List<Recommended_Badge_Mix__c>();
            Boolean updateRecord = true;
            for(Recommended_Badge_Mix__c rbm : testRecommendedBadgeMixes) {
                if(updateRecord) {
                    rbm.Name += ' test';
                    updatedTestRecommendedBadgeMixes.add(rbm);
                }
                updateRecord = !updateRecord;
            }
            update updatedTestRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, NO_EXCEPTION_EXPECTED_MESSAGE);
    }

    @isTest
    private static void testEnforceSingleDefaultMix_updatePositiveBulk() {
        Boolean caughtException = false;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(200, 1);
        
        try {
            insert testRecommendedBadgeMixes;
            List<Recommended_Badge_Mix__c> updatedRecommendedBadgeMixes = new List<Recommended_Badge_Mix__c>();
            Boolean updateRecord = true;
            for(Recommended_Badge_Mix__c rbm : testRecommendedBadgeMixes) {
                if(updateRecord) {
                    rbm.Name += ' test';
                    updatedRecommendedBadgeMixes.add(rbm);
                }
                updateRecord = !updateRecord;
            }
            update updatedRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
        }

        System.assert(!caughtException, NO_EXCEPTION_EXPECTED_MESSAGE);
    }

    @isTest
    private static void testEnforceSingleDefaultMix_updateNegativeBulk() {
        Boolean caughtException = false;
        String exceptionMessage;
        List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = generateTestData(200, 1);
        
        try {
            insert testRecommendedBadgeMixes;
            testRecommendedBadgeMixes[1].Default_Badge_Mix__c = true;
            for(Recommended_Badge_Mix__c rbm : testRecommendedBadgeMixes) {
                rbm.Name += ' test';
            }
            update testRecommendedBadgeMixes;
        } catch(Exception e) {
            caughtException = true;
            exceptionMessage = e.getMessage();
        }

        System.assert(caughtException, 'Expected exception.');
        System.assert(exceptionMessage.contains('Only one recommended badge mix can be marked as the default.'), 'Expected exception with provided message.');
    }
}
