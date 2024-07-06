/**
 * Custom exception to return the stack trace of a DMLException to client.
 * @author Ben Learn
 * @since 01-06-2023
 * @group LWCErrorHandler
 */
public class StackTraceDMLException extends Exception{
    /**
     * Sets cause/message of StackTraceDMLException instance to provided DMLException/provided DMLException's message, respectively
     * @param e 
     */
    public StackTraceDMLException(DMLException e) {
        this.initCause(e);
        this.setMessage(e.getMessage());
    }
}
