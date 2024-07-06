/**
 * Utility class for DML operations.
 * @author Ben Learn
 * @since 06-13-2024
 * @group Core
 */
public with sharing class DMLUtils {
    /**
     * Logs errors from insert calls by processing provided saveResults and using Nebula Logger.
     * @param saveResults 
     * @param callingClassName 
     * @return  `Boolean`  True if any records failed the DML operation.
     */    
    public static Boolean logErrors(List<Database.SaveResult> saveResults, String callingClassName) {
        return logErrors(saveResults, callingClassName, false);
    }

    /**
     * Logs errors from insert and update calls by processing provided saveResults and using Nebula Logger.
     * @param saveResults 
     * @param callingClassName 
     * @param isUpdate
     * @return `Boolean` True if any records failed the DML operation.
     */    
    public static Boolean logErrors(List<Database.SaveResult> saveResults, String callingClassName, Boolean isUpdate) {
        Boolean hasErrors = false;
        for(Database.SaveResult sr : saveResults) {
            if(sr.isSuccess() == false) {
                hasErrors = true;
                if(isUpdate) {
                    Logger.error(new LogMessage('{0}', sr.getErrors()), sr.getId());   
                } else {
                    Logger.error(new LogMessage('{0}', sr.getErrors()));
                }
            }
        }

        if(hasErrors) {
            Logger.info(new LogMessage('DML originated from {0}.', callingClassName));
            Logger.saveLog();
        }
        return hasErrors;
    }

    /**
     * Logs errors from delete calls by processing provided deleteResults and using Nebula Logger.
     * @param deleteResults 
     * @param callingClassName 
     * @return  `Boolean`
     */
    public static Boolean logErrors(List<Database.DeleteResult> deleteResults, String callingClassName) {
        Boolean hasErrors = false;
        for(Database.DeleteResult dr : deleteResults) {
            if(dr.isSuccess() == false) {
                hasErrors = true;
                Logger.error(new LogMessage('{0}', dr.getErrors()), dr.getId());
            }
        }

        if(hasErrors) {
            Logger.info(new LogMessage('DML originated from {0}.', callingClassName));
            Logger.saveLog();
        }
        return hasErrors;
    }
}