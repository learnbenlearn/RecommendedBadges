/**
 * @description       : Test class for SortCustomMetadataController.
 * @author            : Ben Learn
 * @last modified on  : 01-09-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class SortCustomMetadataControllerTests {
    @isTest
    private static void getSortOptions_test() {
        List<Sortable_Field__mdt> sortableFields = [
            SELECT MasterLabel, Field_API_Name__c, Sortable_LWC__r.MasterLabel,
            (SELECT MasterLabel, Sort_Order__c FROM Sortable_Field_Values__r)
            FROM Sortable_Field__mdt
        ];

        String testComponentName;
        if(sortableFields.size() == 0) {
            testComponentName = 'test';
        } else {
            testComponentName = sortableFields[0].Sortable_LWC__r.MasterLabel;
            for(Sortable_Field__mdt sortableField : sortableFields) {
                if(sortableField.Sortable_LWC__r.MasterLabel != testComponentName) {
                    sortableFields.remove(sortableFields.indexOf(sortableField));
                }
            }
        }

        Test.startTest();
        List<Sortable_Field__mdt> sortOptions = SortCustomMetadataController.getSortOptions(testComponentName);
        Test.stopTest();

        Map<Id, Sortable_Field__mdt> sortableFieldMap = new Map<Id, Sortable_Field__mdt>(sortableFields);
        for(Sortable_Field__mdt sortOption : sortOptions) {
            System.assert(sortableFieldMap.containsKey(sortOption.Id), 'Expected sort options to be the same.');
        }
    }
}
