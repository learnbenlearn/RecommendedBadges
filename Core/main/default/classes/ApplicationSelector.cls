/**
 * @description       : Custom fflib_SObjectSelector base class created to provide custom handling of field sets in queries. 
 *                      More on the motivation behind this here => https://github.com/learnbenlearn/RecommendedBadges/wiki/ApplicationSelector-Motivation
 * @author            : Ben Learn
 * @last modified on  : 01-21-2023
 * @last modified by  : Ben Learn
**/
public inherited sharing abstract class ApplicationSelector extends fflib_SObjectSelector {
    List<Schema.FieldSet> enabledFieldSets;

    public ApplicationSelector enableFieldSet(Schema.FieldSet fieldSet) {
        this.enabledFieldSets.add(fieldSet);
        return this;
    }

    public ApplicationSelector enableFieldSets(List<Schema.FieldSet> fieldSets) {
        this.enabledFieldSets.addAll(fieldSets);
        return this;
    }

    public void clearEnabledFieldSets() {
        this.enabledFieldSets.clear();
    }

    public override List<Schema.FieldSet> getSObjectFieldSetList() {
        return this.enabledFieldSets;
    }
}