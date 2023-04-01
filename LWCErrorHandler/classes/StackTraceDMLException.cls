/**
 * @description       : Custom exception to return the stack trace of a DMLException to client.
 * @author            : Ben Learn
 * @last modified on  : 01-06-2023
 * @last modified by  : Ben Learn
**/
public class StackTraceDMLException extends Exception{
    public StackTraceDMLException(DMLException e) {
        this.initCause(e);
        this.setMessage(e.getMessage());
    }
}
