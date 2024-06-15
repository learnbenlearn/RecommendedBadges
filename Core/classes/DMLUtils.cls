/**
 * Utility class for DML operations.
 * @author Ben Learn
 * @since 06-13-2024
 */
public with sharing class DMLUtils {
    /**
     * Logs errors from insert, update, and upsert calls by processing provided saveResults and using Nebula Logger.
     * @param saveResults 
     * @param callingClassName 
     * @return True if any records failed the DML operation.
     */    
    public static Boolean logErrors(List<Database.SaveResult> saveResults, String callingClassName) {
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
        return hasErrors;
    }
}