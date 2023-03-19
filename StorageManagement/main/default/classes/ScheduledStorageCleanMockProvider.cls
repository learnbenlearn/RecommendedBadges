
/**
 * 
 * @description System.StubProvider implementation to stub AsyncApexJobsSelector.selectCompletedJobsByMethod() in ScheduledStorageClean during test executions.
 * @author Ben
 * @since  2023-03-18
 */
@isTest
public class ScheduledStorageCleanMockProvider implements System.StubProvider {
    public Object handleMethodCall(
        Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames, 
        List<Object> listOfArgs
    ) {
        if(stubbedMethodName == 'selectCompletedJobsByMethod') {
            return new List<AsyncApexJob>{
                new AsyncApexJob(
                    Id=fflib_IDGenerator.generate(AsyncApexJob.sObjectType)
                )
            };
        } else {
            return null;
        }
    }
}