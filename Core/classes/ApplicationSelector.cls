/**
 * Custom fflib_SObjectSelector base class created to provide custom handling of field sets in queries. 
 * More on the motivation behind this here => https://github.com/learnbenlearn/RecommendedBadges/wiki/ApplicationSelector-Motivation
 * @author Ben Learn
 * @since 02-05-2023
 * @group Core
 */
public inherited sharing abstract class ApplicationSelector extends fflib_SObjectSelector {
    /**
     * default constructor
     */
    public ApplicationSelector() {
        this(false);
    }

    /**
     * Constructor to call fflib_SObjectSelector constructor with/without field set fields included.
     * @param includeFieldSetFields 
     */
    public ApplicationSelector(Boolean includeFieldSetFields) {
        super(includeFieldSetFields);
    }

    /**
     * Constructor to call fflib_SObjectSelector constructor with/without field set fields included and using specified DataAccess
     * @param includeFieldSetFields 
     * @param dataAccess 
     */    
    public ApplicationSelector(Boolean includeFieldSetFields, fflib_SObjectSelector.DataAccess dataAccess) {
        super(includeFieldSetFields, dataAccess);
    }
}