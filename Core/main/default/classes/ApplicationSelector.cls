/**
 * @description       : Custom fflib_SObjectSelector base class created to provide custom handling of field sets in queries. 
 *                      More on the motivation behind this here => https://github.com/learnbenlearn/RecommendedBadges/wiki/ApplicationSelector-Motivation
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing abstract class ApplicationSelector extends fflib_SObjectSelector {
    public ApplicationSelector() {
        this(false);
    }

    /**
    * @description Constructor to call fflib_SObjectSelector constructor with/without field set fields included.
    * @author Ben Learn | 01-22-2023 
    * @param Boolean includeFieldSetFields 
    **/
    public ApplicationSelector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
    }
}