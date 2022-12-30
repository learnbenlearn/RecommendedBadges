/**
 * @description       : Wrapper class for the RecommendedBadgeMixController.getSetupData(). Combines lists of mix categories grouped by
 *                      recommended badge mix and a string holding the name of the default mix.
 * @author            : Ben Learn
 * @last modified on  : 12-30-2022
 * @last modified by  : Ben Learn
**/
public class SetupDataWrapper {
    @AuraEnabled public Map<String, List<Mix_Category__c>> categoriesByMix {get;set;}
    @AuraEnabled public String defaultMix {get;set;}

    public SetupDataWrapper(Map<String, List<Mix_Category__c>> categoriesByMix, String defaultMix) {
        this.categoriesByMix = categoriesByMix;
        this.defaultMix = defaultMix;
    }
}