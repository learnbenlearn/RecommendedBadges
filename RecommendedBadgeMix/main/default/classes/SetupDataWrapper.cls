/**
 * @description       : Wrapper class for the RecommendedBadgeService.getSetupData(). Combines lists of mix categories grouped by
 *                      recommended badge mix and a string holding the name of the default mix.
 * @author            : Ben Learn
 * @group             : 
 * @last modified on  : 02-25-2022
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