/**
 * @description       : Application class for fflib Factory definitions.
 * @author            : Ben Learn
 * @last modified on  : 03-04-2023
 * @last modified by  : Ben Learn
**/
public class Application {
    // Service factory instantiation
    private static Map<Type, Type> defaultServiceImplementationMap = new Map<Type, Type>();
    static {
        List<DefaultServiceImplementation__mdt> defaultServiceImplementations = new DefaultServiceImplementationsSelector().selectAll();
        for(DefaultServiceImplementation__mdt dsi : defaultServiceImplementations) {
            defaultServiceImplementationMap.put(Type.forName(dsi.DeveloperName), Type.forName(dsi.DefaultImplementation__c));
        }
    }
    public static final fflib_Application.ServiceFactory Service = new fflib_Application.ServiceFactory(defaultServiceImplementationMap);

    // Selector factory instantiation
    private static Map<SObjectType, Type> selectorsBySObject = new Map<SObjectType, Type>();
    static {
        selectorsBySObject.put(DefaultServiceImplementation__mdt.sObjectType, DefaultServiceImplementationsSelector.class);
        selectorsBySObject.put(Mix_Category__c.sObjectType, MixCategoriesSelector.class);
        selectorsBySObject.put(Recommended_Badge_Mix__c.sObjectType, RecommendedBadgeMixesSelector.class);
        selectorsBySObject.put(Recommended_Badge__c.sObjectType, RecommendedBadgesSelector.class);
        selectorsBySObject.put(Recommended_Trail__c.sObjectType, RecommendedTrailsSelector.class);
        selectorsBySObject.put(Task.sObjectType, TasksSelector.class);

        List<DefaultObjectSelector__mdt> defaultObjectSelectors = new DefaultObjectSelectorsSelector().selectAll();
        for(DefaultObjectSelector__mdt defaultObjectSelector : defaultObjectSelectors) {
            String sObjectName = defaultObjectSelector.DeveloperName;
            if(defaultObjectSelector.Suffix__c != null) {
                sObjectName += defaultObjectSelector.Suffix__c;
            }
            selectorsBySObject.put(
                Schema.describeSObjects(new List<String>{sObjectName})[0].getSObjectType(), 
                Type.forName(defaultObjectSelector.DefaultSelector__c)
            );
        }
    }
    public static final fflib_Application.SelectorFactory Selector = new fflib_Application.SelectorFactory(selectorsBySObject);
}
