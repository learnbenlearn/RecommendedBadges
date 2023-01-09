/**
 * @description       : Application class for fflib Factory definitions.
 * @author            : Ben Learn
 * @last modified on  : 01-08-2023
 * @last modified by  : Ben Learn
**/
public class Application {
    private static Map<Type, Type> defaultServiceImplementationMap = new Map<Type, Type>();
    static {
        List<DefaultServiceImplementation__mdt> defaultServiceImplementations = [
            SELECT DeveloperName, DefaultImplementation__c FROM DefaultServiceImplementation__mdt
        ];
        for(DefaultServiceImplementation__mdt dsi : defaultServiceImplementations) {
            defaultServiceImplementationMap.put(Type.forName(dsi.DeveloperName), Type.forName(dsi.DefaultImplementation__c));
        }
    }
    public static final fflib_Application.ServiceFactory Service = new fflib_Application.ServiceFactory(defaultServiceImplementationMap);
}
