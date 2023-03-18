/**
 * @description Utility class to create stub for AsyncApexJobsSelector in ScheduledStorageClean during test execution.
 * @author Ben
 * @since 2023-03-18
 */
public class ScheduledStorageCleanMockUtils {
    /**
     * 
     * @description Instantiate StubProvider implementation.
     * @return  `ScheduledStorageCleanMockProvider`
     */
    public static ScheduledStorageCleanMockProvider getInstance() {
        return new ScheduledStorageCleanMockProvider();
    }
    
    /**
     * 
     * @description Create stub for given type.
     * @param typeToMock 
     * @return  `Object`
     */
    public static Object createMock(Type typeToMock) {
        return Test.createStub(typeToMock, ScheduledStorageCleanMockUtils.getInstance());
    }
}