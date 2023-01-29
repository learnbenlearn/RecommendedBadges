/**
 * @description       : Custom fflib_SObjectSelector base class created to provide custom handling of field sets in queries. 
 *                      More on the motivation behind this here => https://github.com/learnbenlearn/RecommendedBadges/wiki/ApplicationSelector-Motivation
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing abstract class ApplicationSelector extends fflib_SObjectSelector {
    List<Schema.FieldSet> enabledFieldSets;

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
        this.enabledFieldSets = new List<Schema.FieldSet>();
    }

    /**
    * @description Method to enable a field set to be used in a query.
    * @author Ben Learn | 01-22-2023 
    * @param Schema.FieldSet fieldSet 
    * @return ApplicationSelector 
    **/
    public virtual ApplicationSelector enableFieldSet(Schema.FieldSet fieldSet) {
        this.enabledFieldSets.add(fieldSet);
        return this;
    }

    /**
    * @description Method to enable multiple field sets to be used in a query.
    * @author Ben Learn | 01-22-2023 
    * @param List<Schema.FieldSet> fieldSets 
    * @return ApplicationSelector 
    **/
    public virtual ApplicationSelector enableFieldSets(List<Schema.FieldSet> fieldSets) {
        this.enabledFieldSets.addAll(fieldSets);
        return this;
    }

    /**
    * @description Method to clear all currently enabled field sets.
    * @author Ben Learn | 01-22-2023 
    **/
    public void clearEnabledFieldSets() {
        this.enabledFieldSets.clear();
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return this.enabledFieldSets;
    }
}