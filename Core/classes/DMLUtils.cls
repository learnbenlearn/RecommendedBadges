public with sharing class DMLUtils {
    public static void logErrors(List<Database.SaveResult> saveResults, String callingClassName) {
        Boolean hasErrors = false;
        for(Database.SaveResult sr : saveResults) {
            if(sr.isSuccess() == false) {
                hasErrors = true;
                Logger.error(new LogMessage('{0}', sr.getErrors()));
            }
        }

        if(hasErrors) {
            Logger.info(new LogMessage('DML originated from {0}.', callingClassName));
            Logger.saveLog();
        }
    }
}