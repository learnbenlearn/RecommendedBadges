/**
 * @description       : Apex class to retrieve records of the Sortable Field custom metadata type.
 * @author            : Ben Learn
 * @last modified on  : 01-29-2023
 * @last modified by  : Ben Learn
**/
public without sharing class SortCustomMetadataController {
    /**
     * Method to return sortable fields for table and treegrid views.
     * @param componentName 
     * @return  `List<Sortable_Field__mdt>`
     */
     @AuraEnabled(cacheable=true scope='global')
    public static List<Sortable_Field__mdt> getSortOptions(String componentName) {
        return new SortableFieldsSelector().selectByComponentNameWithSortableFieldValues(componentName);
    }
}
