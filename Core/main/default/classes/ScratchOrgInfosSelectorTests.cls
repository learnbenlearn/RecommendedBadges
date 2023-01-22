/**
 * @description       : Test class for ScratchOrgInfosSelector.
 * @author            : Ben Learn
 * @last modified on  : 01-22-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class ScratchOrgInfosSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        if(System.Type.forName('ScratchOrgInfo') != null) {
            List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
                Schema.describeSObjects(new List<String>{'ScratchOrgInfo'})[0].fields.getMap().get('Id')
            };
            Assert.areEqual(expectedFieldList, new ScratchOrgInfosSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
        } else {
            Assert.isNull(new ScratchOrgInfosSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
        }
    }

    @isTest
    private static void getSObjectType_test() {
        if(System.Type.forName('ScratchOrgInfo') != null) {
            Assert.areEqual(
                Schema.describeSObjects(new List<String>{'ScratchOrgInfo'})[0].getSObjectType(), 
                new ScratchOrgInfosSelector().getSObjectType(), 
                SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE
            );
        } else {
            Assert.isNull(new ScratchOrgInfosSelector().getSObjectType());
        }
    }
}