/**
 * @description       : Test class for TrailsSelector.
 * @author            : Ben Learn
 * @last modified on  : 02-05-2023
 * @last modified by  : Ben Learn
**/
@isTest
private class TrailsSelectorTests {
    @isTest
    private static void getSObjectFieldList_test() {
        List<Schema.SObjectField> expectedFieldList = new List<Schema.SObjectField> {
            trailheadapp__Trail__c.Id
        };

        Assert.areEqual(expectedFieldList, new TrailsSelector().getSObjectFieldList(), SelectorTestErrorMessages.SOBJECT_FIELD_LIST_ERROR_MESSAGE);
    }

    @isTest
    private static void getSObjectType_test() {
        Assert.areEqual(trailheadapp__Trail__c.sObjectType, new TrailsSelector().getSObjectType(), SelectorTestErrorMessages.SOBJECT_TYPE_ERROR_MESSAGE);
    }

    @isTest
    private static void selectById_test() {
        TestDataFactory.Trail trailGenerator = new TestDataFactory.Trail(true, true);
        Map<Id, trailheadapp__Trail__c> testTrailsById = new Map<Id, trailheadapp__Trail__c>((List<trailheadapp__Trail__c>) trailGenerator.execute());
        
        Set<Id> expectedTrailIds = new Set<Id>();
        Integer counter = 0;
        for(Id trailId : testTrailsById.keySet()) {
            if(counter >= testTrailsById.size() / 2) break;
            expectedTrailIds.add(trailId);
            counter += 1;
        }

        Map<Id, trailheadapp__Trail__c> resultTrailsById = new Map<Id, trailheadapp__Trail__c>(new TrailsSelector().selectById(expectedTrailIds));
        Assert.areEqual(expectedTrailIds, resultTrailsById.keySet(), 'Expected Trails with provided IDs to be retrieved.');
    }
}