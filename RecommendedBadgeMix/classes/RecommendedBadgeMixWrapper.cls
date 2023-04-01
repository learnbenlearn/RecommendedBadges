/**
 * @description       : Wrapper class for the RecommendedBadgeMixController.getData() method. Combines lists of mix categories grouped by
 *                      recommended badge mix and a string holding the name of the default mix.
 * @author            : Ben Learn
 * @last modified on  : 02-07-2023
 * @last modified by  : Ben Learn
**/
public class RecommendedBadgeMixWrapper {
    @AuraEnabled public Map<String, List<Mix_Category__c>> categoriesByMix {get;set;}
    @AuraEnabled public String defaultMix {get;set;}

    public RecommendedBadgeMixWrapper(Map<String, List<Mix_Category__c>> categoriesByMix, String defaultMix) {
        this.categoriesByMix = categoriesByMix;
        this.defaultMix = defaultMix;
    }
}