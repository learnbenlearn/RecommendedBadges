export default [
    {
        "title": "Home",
        "fileName": "index.html",
        "text": "Home Recommended Badges Check out the Recommended Badges wiki !"
    },
    {
        "title": "Application",
        "fileName": "Application.html",
        "text": "Application : Application class for fflib Factory definitions. Signature public class Application Author : Ben Learn @last modified on  : 03-04-2023 @last modified by  : Ben Learn Application Properties Name Signature Selector public static final fflib_Application.SelectorFactory Selector Service public static final fflib_Application.ServiceFactory Service"
    },
    {
        "title": "ApplicationSelector",
        "fileName": "ApplicationSelector.html",
        "text": "ApplicationSelector : Custom fflib_SObjectSelector base class created to provide custom handling of field sets in queries. More on the motivation behind this here => https://github.com/learnbenlearn/RecommendedBadges/wiki/ApplicationSelector-Motivation Signature public inherited sharing abstract class ApplicationSelector extends fflib_SObjectSelector Author : Ben Learn @last modified on  : 02-05-2023 @last modified by  : Ben Learn ApplicationSelector Constructors ApplicationSelector() ApplicationSelector(includeFieldSetFields) Constructor to call fflib_SObjectSelector constructor with/without field set fields included. ApplicationSelector() Signature public ApplicationSelector() ApplicationSelector(includeFieldSetFields) Constructor to call fflib_SObjectSelector constructor with/without field set fields included. Signature public ApplicationSelector(Boolean includeFieldSetFields) Parameters Boolean includeFieldSetFields Author Ben Learn | 01-22-2023"
    },
    {
        "title": "Badges",
        "fileName": "Badges.html",
        "text": "Badges Signature public with sharing class Badges Badges Constructors Badges() Badges() Signature public Badges()"
    },
    {
        "title": "BadgesSelector",
        "fileName": "BadgesSelector.html",
        "text": "BadgesSelector : Selector class for the Badge custom object from the Trail Tracker managed package. Signature public inherited sharing class BadgesSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 02-05-2023 @last modified by  : Ben Learn BadgesSelector Methods getSObjectFieldList() getSObjectType() selectAllArchivedOrInProductsToDelete(badgeProductsToDelete, badgesToKeepNames) selectById(badgeIds) getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectAllArchivedOrInProductsToDelete(badgeProductsToDelete, badgesToKeepNames) Signature public List<trailheadapp__Badge__c> selectAllArchivedOrInProductsToDelete(List<String> badgeProductsToDelete, List<String> badgesToKeepNames) selectById(badgeIds) Signature public List<trailheadapp__Badge__c> selectById(Set<Id> badgeIds)"
    },
    {
        "title": "DebugLogsSelector",
        "fileName": "DebugLogsSelector.html",
        "text": "DebugLogsSelector : Selector class for the Debug Log custom object from the Trail Tracker managed package. Signature public inherited sharing class DebugLogsSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-22-2023 @last modified by  : Ben Learn DebugLogsSelector Methods getSObjectFieldList() getSObjectType() selectAll() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectAll() Signature public List<trailheadapp__Debug_Log__c> selectAll()"
    },
    {
        "title": "DefaultObjectSelectorsSelector",
        "fileName": "DefaultObjectSelectorsSelector.html",
        "text": "DefaultObjectSelectorsSelector : Selector class for Default Object Selector custom metadata type. Signature public inherited sharing class DefaultObjectSelectorsSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-29-2023 @last modified by  : Ben Learn DefaultObjectSelectorsSelector Methods getSObjectFieldList() getSObjectType() selectAll() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectAll() Signature public List<DefaultObjectSelector__mdt> selectAll()"
    },
    {
        "title": "DefaultServiceImplementationsSelector",
        "fileName": "DefaultServiceImplementationsSelector.html",
        "text": "DefaultServiceImplementationsSelector : Selector class for Default Service Implementation custom metadata type. Signature public inherited sharing class DefaultServiceImplementationsSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-22-2023 @last modified by  : Ben Learn DefaultServiceImplementationsSelector Methods getSObjectFieldList() getSObjectType() selectAll() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectAll() Signature public List<DefaultServiceImplementation__mdt> selectAll()"
    },
    {
        "title": "MixCategoriesSelector",
        "fileName": "MixCategoriesSelector.html",
        "text": "MixCategoriesSelector : Selector class for Mix Category custom object. Signature public inherited sharing class MixCategoriesSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 02-16-2023 @last modified by  : Ben Learn MixCategoriesSelector Methods getSObjectFieldList() getSObjectType() selectAllWithRecommendedBadgeMixInfos(fieldSet) selectByIdWithRecommendedBadgeMixNames(mixCategoryIds) selectRecommendedBadgesAndTrails() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectAllWithRecommendedBadgeMixInfos(fieldSet) Signature public List<Mix_Category__c> selectAllWithRecommendedBadgeMixInfos(Schema.FieldSet fieldSet) selectByIdWithRecommendedBadgeMixNames(mixCategoryIds) Signature public List<Mix_Category__c> selectByIdWithRecommendedBadgeMixNames(Set<Id> mixCategoryIds) selectRecommendedBadgesAndTrails() Signature public List<Mix_Category__c> selectRecommendedBadgesAndTrails()"
    },
    {
        "title": "RecommendedBadgeMixes",
        "fileName": "RecommendedBadgeMixes.html",
        "text": "RecommendedBadgeMixes Signature public with sharing class RecommendedBadgeMixes RecommendedBadgeMixes Constructors RecommendedBadgeMixes() RecommendedBadgeMixes() Signature public RecommendedBadgeMixes()"
    },
    {
        "title": "RecommendedBadgeMixesSelector",
        "fileName": "RecommendedBadgeMixesSelector.html",
        "text": "RecommendedBadgeMixesSelector : Selector class for Recommended Badge Mix custom object. Signature public inherited sharing class RecommendedBadgeMixesSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 02-05-2023 @last modified by  : Ben Learn RecommendedBadgeMixesSelector Constructors RecommendedBadgeMixesSelector() RecommendedBadgeMixesSelector(includeFieldSetFields) RecommendedBadgeMixesSelector() Signature public RecommendedBadgeMixesSelector() RecommendedBadgeMixesSelector(includeFieldSetFields) Signature public RecommendedBadgeMixesSelector(Boolean includeFieldSetFields) RecommendedBadgeMixesSelector Methods getSObjectFieldList() getSObjectType() selectDefaultMix() selectExistingDefaultMix(mixIdsToExclude) getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectDefaultMix() Signature public List<Recommended_Badge_Mix__c> selectDefaultMix() selectExistingDefaultMix(mixIdsToExclude) Signature public List<Recommended_Badge_Mix__c> selectExistingDefaultMix(List<Id> mixIdsToExclude)"
    },
    {
        "title": "RecommendedBadges",
        "fileName": "RecommendedBadges.html",
        "text": "RecommendedBadges Signature public with sharing class RecommendedBadges RecommendedBadges Constructors RecommendedBadges() RecommendedBadges() Signature public RecommendedBadges()"
    },
    {
        "title": "RecommendedBadgesSelector",
        "fileName": "RecommendedBadgesSelector.html",
        "text": "RecommendedBadgesSelector : Selector class for Recommended Badge custom object. Signature public inherited sharing class RecommendedBadgesSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 02-16-2023 @last modified by  : Ben Learn RecommendedBadgesSelector Methods getSObjectFieldList() getSObjectType() selectByBadges(badgeIds) selectedAllRelatedToUserPrivateMix() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.sObjectType getSObjectType() selectByBadges(badgeIds) Signature public List<Recommended_Badge__c> selectByBadges(Set<Id> badgeIds) selectedAllRelatedToUserPrivateMix() Signature public List<Recommended_Badge__c> selectedAllRelatedToUserPrivateMix()"
    },
    {
        "title": "RecommendedTrails",
        "fileName": "RecommendedTrails.html",
        "text": "RecommendedTrails Signature public with sharing class RecommendedTrails RecommendedTrails Constructors RecommendedTrails() RecommendedTrails() Signature public RecommendedTrails()"
    },
    {
        "title": "RecommendedTrailsSelector",
        "fileName": "RecommendedTrailsSelector.html",
        "text": "RecommendedTrailsSelector : Selector class for Recommended Trail custom object. Signature public inherited sharing class RecommendedTrailsSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-29-2023 @last modified by  : Ben Learn RecommendedTrailsSelector Methods getSObjectFieldList() getSObjectType() selectByTrails(trailIds) getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectByTrails(trailIds) Signature public List<Recommended_Trail__c> selectByTrails(Set<Id> trailIds)"
    },
    {
        "title": "SelectorTestErrorMessages",
        "fileName": "SelectorTestErrorMessages.html",
        "text": "SelectorTestErrorMessages : Test class to hold error messages for selector test methods. Signature @isTest public class SelectorTestErrorMessages Author : Ben Learn @last modified on  : 01-22-2023 @last modified by  : Ben Learn SelectorTestErrorMessages Properties Name Signature SOBJECT_FIELD_LIST_ERROR_MESSAGE public static final String SOBJECT_FIELD_LIST_ERROR_MESSAGE SOBJECT_TYPE_ERROR_MESSAGE public static final String SOBJECT_TYPE_ERROR_MESSAGE"
    },
    {
        "title": "TasksSelector",
        "fileName": "TasksSelector.html",
        "text": "TasksSelector : Selector for Task standard object. Signature public inherited sharing class TasksSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-22-2023 @last modified by  : Ben Learn TasksSelector Methods getSObjectFieldList() getSObjectType() selectOpen() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectOpen() Signature public List<Task> selectOpen()"
    },
    {
        "title": "TestDataFactory",
        "fileName": "TestDataFactory.html",
        "text": "TestDataFactory : Test data factory for the Recommended Badges application. Currently inserts data into the database, will likely be refactored to be used with mocks in the future. Signature @isTest public class TestDataFactory Author : Ben Learn @last modified on  : 02-20-2023 @last modified by  : Ben Learn TestDataFactory Methods execute() execute() execute() MixCategory(insertRecords, returnCreatedRecords, numberToGenerate, recommendedBadgeMixes) execute() Signature public List<sObject> execute() execute() Signature public List<sObject> execute() execute() Signature public List<sObject> execute() MixCategory(insertRecords, returnCreatedRecords, numberToGenerate, recommendedBadgeMixes) Signature public MixCategory(Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate, List<Recommended_Badge_Mix__c> recommendedBadgeMixes) TestDataFactory.Badge Signature public class Badge extends RecordGenerationTemplate implements RecordGeneration TestDataFactory.Badge Properties Name Signature BADGE_PRODUCTS public final List<String> BADGE_PRODUCTS BADGES_TO_KEEP public final List<String> BADGES_TO_KEEP INCLUDE_ARCHIVED_BADGES public final Boolean INCLUDE_ARCHIVED_BADGES INCLUDE_BADGE_PRODUCTS public final Boolean INCLUDE_BADGE_PRODUCTS INCLUDE_BADGES_TO_KEEP public final Boolean INCLUDE_BADGES_TO_KEEP TestDataFactory.Badge Constructors Badge(insertRecords, returnCreatedRecords) Badge(insertRecords, returnCreatedRecords, includeArchivedBadges, includeBadgeProducts, includeBadgesToKeep, badgeProducts, badgesToKeep) Badge(insertRecords, returnCreatedRecords) Signature public Badge(Boolean insertRecords, Boolean returnCreatedRecords) Badge(insertRecords, returnCreatedRecords, includeArchivedBadges, includeBadgeProducts, includeBadgesToKeep, badgeProducts, badgesToKeep) Signature public Badge(            Boolean insertRecords, Boolean returnCreatedRecords, Boolean includeArchivedBadges, Boolean includeBadgeProducts, Boolean includeBadgesToKeep,             List<String> badgeProducts, List<String> badgesToKeep        ) TestDataFactory.DebugLog Signature public class DebugLog extends RecordGenerationTemplate implements RecordGeneration TestDataFactory.DebugLog Constructors DebugLog(insertRecords, returnCreatedRecords) DebugLog(insertRecords, returnCreatedRecords) Signature public DebugLog(Boolean insertRecords, Boolean returnCreatedRecords) TestDataFactory.MixCategory Signature public class MixCategory extends RecordGenerationTemplate implements RecordGeneration TestDataFactory.MixCategory Properties Name Signature RECOMMENDED_BADGE_MIXES public final List<Recommended_Badge_Mix__c> RECOMMENDED_BADGE_MIXES TestDataFactory.MixCategory Constructors MixCategory(insertRecords, returnCreatedRecords, recommendedBadgeMixes) MixCategory(insertRecords, returnCreatedRecords, recommendedBadgeMixes) Signature public MixCategory(Boolean insertRecords, Boolean returnCreatedRecords, List<Recommended_Badge_Mix__c> recommendedBadgeMixes) TestDataFactory.RecommendedBadge Signature public class RecommendedBadge extends RecordGenerationTemplate implements RecordGeneration TestDataFactory.RecommendedBadge Properties Name Signature BADGES public final List<trailheadapp__Badge__c> BADGES BYPASS_DUPLICATE_RULES public final Boolean BYPASS_DUPLICATE_RULES MIX_CATEGORIES public final List<Mix_Category__c> MIX_CATEGORIES TestDataFactory.RecommendedBadge Constructors RecommendedBadge(insertRecords, returnCreatedRecords, badges, mixCategories, bypassDuplicateRules) RecommendedBadge(insertRecords, returnCreatedRecords, numberToGenerate, badges, mixCategories, bypassDuplicateRules) RecommendedBadge(insertRecords, returnCreatedRecords, badges, mixCategories, bypassDuplicateRules) Signature public RecommendedBadge(            Boolean insertRecords, Boolean returnCreatedRecords, List<trailheadapp__Badge__c> badges, List<Mix_Category__c> mixCategories, Boolean bypassDuplicateRules        ) RecommendedBadge(insertRecords, returnCreatedRecords, numberToGenerate, badges, mixCategories, bypassDuplicateRules) Signature public RecommendedBadge(            Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate, List<trailheadapp__Badge__c> badges, List<Mix_Category__c> mixCategories,             Boolean bypassDuplicateRules        ) TestDataFactory.RecommendedBadge Methods execute() execute() Signature public List<sObject> execute() TestDataFactory.RecommendedBadgeMix Signature public class RecommendedBadgeMix extends RecordGenerationTemplate implements RecordGeneration TestDataFactory.RecommendedBadgeMix Properties Name Signature BYPASS_DUPLICATE_RULES public final Boolean BYPASS_DUPLICATE_RULES INCLUDE_DEFAULT_MIX public final Boolean INCLUDE_DEFAULT_MIX TestDataFactory.RecommendedBadgeMix Constructors RecommendedBadgeMix(insertRecords, returnCreatedRecords) RecommendedBadgeMix(insertRecords, returnCreatedRecords, numberToGenerate, includeDefaultMix, bypassDuplicateRules) RecommendedBadgeMix(insertRecords, returnCreatedRecords) Signature public RecommendedBadgeMix(Boolean insertRecords, Boolean returnCreatedRecords) RecommendedBadgeMix(insertRecords, returnCreatedRecords, numberToGenerate, includeDefaultMix, bypassDuplicateRules) Signature public RecommendedBadgeMix(Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate, Boolean includeDefaultMix, Boolean bypassDuplicateRules) TestDataFactory.RecommendedBadgeMix Methods execute() execute() Signature public List<sObject> execute() TestDataFactory.RecommendedTrail Signature public class RecommendedTrail extends RecordGenerationTemplate implements RecordGeneration TestDataFactory.RecommendedTrail Properties Name Signature BYPASS_DUPLICATE_RULES public final Boolean BYPASS_DUPLICATE_RULES MIX_CATEGORIES public final List<Mix_Category__c> MIX_CATEGORIES TRAILS public final List<trailheadapp__Trail__c> TRAILS TestDataFactory.RecommendedTrail Constructors RecommendedTrail(insertRecords, returnCreatedRecords, trails, mixCategories, bypassDuplicateRules) RecommendedTrail(insertRecords, returnCreatedRecords, numberToGenerate, trails, mixCategories, bypassDuplicateRules) RecommendedTrail(insertRecords, returnCreatedRecords, trails, mixCategories, bypassDuplicateRules) Signature public RecommendedTrail(            Boolean insertRecords, Boolean returnCreatedRecords, List<trailheadapp__Trail__c> trails, List<Mix_Category__c> mixCategories, Boolean bypassDuplicateRules        ) RecommendedTrail(insertRecords, returnCreatedRecords, numberToGenerate, trails, mixCategories, bypassDuplicateRules) Signature public RecommendedTrail(            Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate, List<trailheadapp__Trail__c> trails, List<Mix_Category__c> mixCategories,             Boolean bypassDuplicateRules        ) TestDataFactory.RecommendedTrail Methods execute() execute() Signature public List<sObject> execute() TestDataFactory.RecordGeneration Signature public interface RecordGeneration TestDataFactory.RecordGeneration Methods execute() execute() Signature List<sObject> execute() TestDataFactory.RecordGenerationTemplate Signature public abstract class RecordGenerationTemplate TestDataFactory.RecordGenerationTemplate Properties Name Signature INSERT_RECORDS public final Boolean INSERT_RECORDS NUMBER_TO_GENERATE public final Integer NUMBER_TO_GENERATE RETURN_CREATED_RECORDS public final Boolean RETURN_CREATED_RECORDS TestDataFactory.RecordGenerationTemplate Constructors RecordGenerationTemplate(insertRecords, returnCreatedRecords) RecordGenerationTemplate(insertRecords, returnCreatedRecords, numberToGenerate) RecordGenerationTemplate(insertRecords, returnCreatedRecords) Signature public RecordGenerationTemplate(Boolean insertRecords, Boolean returnCreatedRecords) RecordGenerationTemplate(insertRecords, returnCreatedRecords, numberToGenerate) Signature public RecordGenerationTemplate(Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate) TestDataFactory.Task Signature public class Task extends RecordGenerationTemplate implements RecordGeneration TestDataFactory.Task Constructors Task(insertRecords, returnCreatedRecords) Task(insertRecords, returnCreatedRecords, numberToGenerate) Task(insertRecords, returnCreatedRecords) Signature public Task(Boolean insertRecords, Boolean returnCreatedRecords) Task(insertRecords, returnCreatedRecords, numberToGenerate) Signature public Task(Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate) TestDataFactory.Task Methods execute() testTasks.add() execute() Signature public List<sObject> execute() testTasks.add() Signature testTasks.add(new Schema.Task(Status                } else {                    testTasks.add(new Schema.Task(Status='Completed')) TestDataFactory.Trail Signature public class Trail extends RecordGenerationTemplate implements RecordGeneration TestDataFactory.Trail Properties Name Signature INCLUDE_ARCHIVED_TRAILS public final Boolean INCLUDE_ARCHIVED_TRAILS INCLUDE_TRAIL_PRODUCTS public final Boolean INCLUDE_TRAIL_PRODUCTS TRAIL_PRODUCTS public final List<String> TRAIL_PRODUCTS TestDataFactory.Trail Constructors Trail(insertRecords, returnCreatedRecords) Trail(insertRecords, returnCreatedRecords, includeArchivedTrails, includeTrailProducts, trailProducts) Trail(insertRecords, returnCreatedRecords) Signature public Trail(Boolean insertRecords, Boolean returnCreatedRecords) Trail(insertRecords, returnCreatedRecords, includeArchivedTrails, includeTrailProducts, trailProducts) Signature public Trail(Boolean insertRecords, Boolean returnCreatedRecords, Boolean includeArchivedTrails, Boolean includeTrailProducts, List<String> trailProducts) TestDataFactory.Trail Methods execute() execute() Signature public List<sObject> execute() TestDataFactory.Trailmix Signature public class Trailmix extends RecordGenerationTemplate implements RecordGeneration TestDataFactory.Trailmix Constructors Trailmix(insertRecords, returnCreatedRecords) Trailmix(insertRecords, returnCreatedRecords) Signature public Trailmix(Boolean insertRecords, Boolean returnCreatedRecords) TestDataFactory.Trailmix Methods execute() execute() Signature public List<sObject> execute() TestDataFactory.UserBadge Signature public class UserBadge extends RecordGenerationTemplate implements RecordGeneration TestDataFactory.UserBadge Properties Name Signature BADGES public final List<trailheadapp__Badge__c> BADGES TestDataFactory.UserBadge Constructors UserBadge(insertRecords, returnCreatedRecords, badges) UserBadge(insertRecords, returnCreatedRecords, badges) Signature public UserBadge(Boolean insertRecords, Boolean returnCreatedRecords, List<trailheadapp__Badge__c> badges) TestDataFactory.UserBadge Methods execute() execute() Signature public List<sObject> execute()"
    },
    {
        "title": "TrailheadEntityFormController",
        "fileName": "TrailheadEntityFormController.html",
        "text": "TrailheadEntityFormController Apex controller for trailheadEntityForm LWC. Signature public with sharing class TrailheadEntityFormController Author Ben Learn Since 06-08-2024 TrailheadEntityFormController Methods getTrailheadEntitiesByAPIName(childEntityType) Returns all the names and API names of all non-archived Badges(when childEntityType is Recommended_Badge__c) or Trails(when childEntityType is Recommended_Trail__c) through a SOQL query using the standard Salesforce REST API on Trail Tracker Provider. getTrailheadEntitiesByAPIName(childEntityType) Returns all the names and API names of all non-archived Badges(when childEntityType is Recommended_Badge__c) or Trails(when childEntityType is Recommended_Trail__c) through a SOQL query using the standard Salesforce REST API on Trail Tracker Provider. Signature @AuraEnabled(cacheable=true) public static Map<String, Object> getTrailheadEntitiesByAPIName(String childEntityType) Parameters childEntityType Type: String Returns Map<String, Object>"
    },
    {
        "title": "TrailmixesSelector",
        "fileName": "TrailmixesSelector.html",
        "text": "TrailmixesSelector : Selector class for the Trailmix custom object from the Trail Tracker managed package. Signature public inherited sharing class TrailmixesSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-22-2023 @last modified by  : Ben Learn TrailmixesSelector Methods getSObjectFieldList() getSObjectType() selectAll() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectAll() Signature public List<trailheadapp__Trailmix__c> selectAll()"
    },
    {
        "title": "Trails",
        "fileName": "Trails.html",
        "text": "Trails Signature public with sharing class Trails Trails Constructors Trails() Trails() Signature public Trails()"
    },
    {
        "title": "TrailsSelector",
        "fileName": "TrailsSelector.html",
        "text": "TrailsSelector : Selector class for the Trail custom object from the Trail Tracker managed package. Signature public inherited sharing class TrailsSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 02-05-2023 @last modified by  : Ben Learn TrailsSelector Methods getSObjectFieldList() getSObjectType() selectAllArchivedOrInProductsToDelete(trailProductsToDelete) selectById(trailIds) getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectAllArchivedOrInProductsToDelete(trailProductsToDelete) Signature public List<trailheadapp__Trail__c> selectAllArchivedOrInProductsToDelete(List<String> trailProductsToDelete) selectById(trailIds) Signature public List<trailheadapp__Trail__c> selectById(Set<Id> trailIds)"
    },
    {
        "title": "UserBadgesSelector",
        "fileName": "UserBadgesSelector.html",
        "text": "UserBadgesSelector : Selector class for the User Badge custom object from the Trail Tracker managed package. Signature public inherited sharing class UserBadgesSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-22-2023 @last modified by  : Ben Learn UserBadgesSelector Methods getSObjectFieldList() getSObjectType() selectAll() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectAll() Signature public List<trailheadapp__User_Badge__c> selectAll()"
    },
    {
        "title": "StackTraceDMLException",
        "fileName": "StackTraceDMLException.html",
        "text": "StackTraceDMLException : Custom exception to return the stack trace of a DMLException to client. Signature public class StackTraceDMLException extends Exception Author : Ben Learn @last modified on  : 01-06-2023 @last modified by  : Ben Learn StackTraceDMLException Constructors StackTraceDMLException(e) StackTraceDMLException(e) Signature public StackTraceDMLException(DMLException e)"
    },
    {
        "title": "PrivateViewController",
        "fileName": "PrivateViewController.html",
        "text": "PrivateViewController : Apex controller for privateViewContainer LWC. Signature public with sharing class PrivateViewController Author : Ben Learn @last modified on  : 02-16-2023 @last modified by  : Ben Learn PrivateViewController Methods getMixCategoryData() Method to retrieve names of mix categories, names of parent Recommended Badge Mixes, and privacy status of parent Recommended Badge Mixes. getPrivateMixRecommendedBadges() Method to retrieve recommended badges for personal recommended badge mix. getMixCategoryData() Method to retrieve names of mix categories, names of parent Recommended Badge Mixes, and privacy status of parent Recommended Badge Mixes. Signature @AuraEnabled(cacheable=true) public static List<Mix_Category__c> getMixCategoryData() Returns List<Mix_Category__c> Author Ben Learn | 03-11-2022 getPrivateMixRecommendedBadges() Method to retrieve recommended badges for personal recommended badge mix. Signature @AuraEnabled public static Map<String, List<Recommended_Badge__c>> getPrivateMixRecommendedBadges() Returns Map<String, List<Recommended_Badge__c>> Author Ben Learn | 03-11-2022"
    },
    {
        "title": "RecommendedBadgeMixController",
        "fileName": "RecommendedBadgeMixController.html",
        "text": "RecommendedBadgeMixController : Apex controller for recommendedBadgeMixContainer LWC. Signature public without sharing class RecommendedBadgeMixController Author : Ben Learn @last modified on  : 02-07-2023 @last modified by  : Ben Learn RecommendedBadgeMixController Properties Name Signature Annotations categoriesByMix public Map<String, List<Mix_Category__c>> categoriesByMix @AuraEnabled defaultMix public String defaultMix @AuraEnabled RecommendedBadgeMixController Methods getData() Method to retrieve necessary data - including mix categories, recommended badges, and recommended trails for public recommended badge mixes, as well as the name of the default mix - for recommendedBadgeMixContainer. getData() Method to retrieve necessary data - including mix categories, recommended badges, and recommended trails for public recommended badge mixes, as well as the name of the default mix - for recommendedBadgeMixContainer. Signature @AuraEnabled(cacheable=true) public static DataWrapper getData() Returns RecommendedBadgeMixWrapper Author Ben Learn | 03-11-2022"
    },
    {
        "title": "SortCustomMetadataController",
        "fileName": "SortCustomMetadataController.html",
        "text": "SortCustomMetadataController : Apex class to retrieve records of the Sortable Field custom metadata type. Signature public without sharing class SortCustomMetadataController Author : Ben Learn @last modified on  : 01-29-2023 @last modified by  : Ben Learn SortCustomMetadataController Methods getSortOptions(componentName) Method to return sortable fields for table and treegrid views. getSortOptions(componentName) Method to return sortable fields for table and treegrid views. Signature @AuraEnabled(cacheable=true) public static List<Sortable_Field__mdt> getSortOptions(String componentName) Parameters String componentName Returns List<Sortable_Field__mdt> Author Ben Learn | 03-13-2022"
    },
    {
        "title": "SortableFieldValuesSelector",
        "fileName": "SortableFieldValuesSelector.html",
        "text": "SortableFieldValuesSelector : Selector class for Sortable Field Value custom metadata type. Signature public inherited sharing class SortableFieldValuesSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-22-2023 @last modified by  : Ben Learn SortableFieldValuesSelector Methods getSObjectFieldList() getSObjectType() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType()"
    },
    {
        "title": "SortableFieldsSelector",
        "fileName": "SortableFieldsSelector.html",
        "text": "SortableFieldsSelector : Selector class for Sortable Field custom metadata type. Signature public inherited sharing class SortableFieldsSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-29-2023 @last modified by  : Ben Learn SortableFieldsSelector Methods getSObjectFieldList() getSObjectType() selectByComponentNameWithSortableFieldValues(componentName) getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectByComponentNameWithSortableFieldValues(componentName) Signature public List<Schema.Sortable_Field__mdt> selectByComponentNameWithSortableFieldValues(String componentName)"
    },
    {
        "title": "TestErrorMessages",
        "fileName": "TestErrorMessages.html",
        "text": "TestErrorMessages : Test class to hold error messages for selector test methods. Signature @isTest public class TestErrorMessages Author : Ben Learn @last modified on  : 01-28-2023 @last modified by  : Ben Learn TestErrorMessages Properties Name Signature SOBJECT_FIELD_LIST_ERROR_MESSAGE public static final String SOBJECT_FIELD_LIST_ERROR_MESSAGE SOBJECT_TYPE_ERROR_MESSAGE public static final String SOBJECT_TYPE_ERROR_MESSAGE"
    },
    {
        "title": "AsyncApexJobsSelector",
        "fileName": "AsyncApexJobsSelector.html",
        "text": "AsyncApexJobsSelector : Selector class for Async Apex Job object. Signature public inherited sharing class AsyncApexJobsSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-22-2023 @last modified by  : Ben Learn AsyncApexJobsSelector Methods getSObjectFieldList() getSObjectType() selectCompletedJobsByMethod(methodName) getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectCompletedJobsByMethod(methodName) Signature public List<AsyncApexJob> selectCompletedJobsByMethod(String methodName)"
    },
    {
        "title": "BadgesToKeepSelector",
        "fileName": "BadgesToKeepSelector.html",
        "text": "BadgesToKeepSelector : Selector class for Badge to Keep custom metadata type. Signature public inherited sharing class BadgesToKeepSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-22-2023 @last modified by  : Ben Learn BadgesToKeepSelector Methods getSObjectFieldList() getSObjectType() selectAll() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectAll() Signature public List<Badge_to_Keep__mdt> selectAll()"
    },
    {
        "title": "IStorageManagementService",
        "fileName": "IStorageManagementService.html",
        "text": "IStorageManagementService : Interface for storage management service layer. Signature public interface IStorageManagementService Author : Ben Learn @last modified on  : 01-08-2023 @last modified by  : Ben Learn IStorageManagementService Methods clean() clean() Signature List<String> clean()"
    },
    {
        "title": "ProductsToDeleteSelector",
        "fileName": "ProductsToDeleteSelector.html",
        "text": "ProductsToDeleteSelector : Selector class for Product to Delete custom metadata type. Signature public inherited sharing class ProductsToDeleteSelector extends ApplicationSelector Author : Ben Learn @last modified on  : 01-29-2023 @last modified by  : Ben Learn ProductsToDeleteSelector Methods getSObjectFieldList() getSObjectType() selectAll() getSObjectFieldList() Signature public List<Schema.SObjectField> getSObjectFieldList() getSObjectType() Signature public Schema.SObjectType getSObjectType() selectAll() Signature public List<Product_to_Delete__mdt> selectAll()"
    },
    {
        "title": "ScheduledStorageClean",
        "fileName": "ScheduledStorageClean.html",
        "text": "ScheduledStorageClean : Schedulable Apex class to clear storage space by deleting unused records created by Trail Tracker app. Signature public without sharing class ScheduledStorageClean implements Schedulable Author : Ben Learn ScheduledStorageClean Methods execute(sc) Scheduled method to clear storage space. execute(sc) Scheduled method to clear storage space. Signature public void execute(SchedulableContext sc) Parameters SchedulableContext sc Author Ben Learn | 03-23-2022"
    },
    {
        "title": "ScheduledStorageCleanMockProvider",
        "fileName": "ScheduledStorageCleanMockProvider.html",
        "text": "ScheduledStorageCleanMockProvider System.StubProvider implementation to stub AsyncApexJobsSelector.selectCompletedJobsByMethod() in ScheduledStorageClean during test executions. Signature @isTest public class ScheduledStorageCleanMockProvider implements System.StubProvider Author Ben Since 2023-03-18 ScheduledStorageCleanMockProvider Methods handleMethodCall(stubbedObject, stubbedMethodName, returnType, listOfParamTypes, listOfParamNames, listOfArgs) handleMethodCall(stubbedObject, stubbedMethodName, returnType, listOfParamTypes, listOfParamNames, listOfArgs) Signature public Object handleMethodCall(        Object stubbedObject, String stubbedMethodName, Type returnType, List<Type> listOfParamTypes, List<String> listOfParamNames,         List<Object> listOfArgs    )"
    },
    {
        "title": "ScheduledStorageCleanMockUtils",
        "fileName": "ScheduledStorageCleanMockUtils.html",
        "text": "ScheduledStorageCleanMockUtils Utility class to create stub for AsyncApexJobsSelector in ScheduledStorageClean during test execution. Signature public class ScheduledStorageCleanMockUtils Author Ben Since 2023-03-18 ScheduledStorageCleanMockUtils Methods createMock(typeToMock) Create stub for given type. getInstance() Instantiate StubProvider implementation. createMock(typeToMock) Create stub for given type. Signature public static Object createMock(Type typeToMock) Parameters typeToMock Type: Type Returns Object getInstance() Instantiate StubProvider implementation. Signature public static ScheduledStorageCleanMockProvider getInstance() Returns ScheduledStorageCleanMockProvider"
    },
    {
        "title": "StorageLimitsController",
        "fileName": "StorageLimitsController.html",
        "text": "StorageLimitsController : Apex controller for storageLimits LWC. Signature public without sharing class StorageLimitsController Author : Ben Learn StorageLimitsController Methods getStorageLimitInfo() Method to retrieve available and consumed org storage. getStorageLimitInfo() Method to retrieve available and consumed org storage. Signature @AuraEnabled public static Map<String, String> getStorageLimitInfo() Returns Map<String, String> Author Ben Learn | 02-27-2022"
    },
    {
        "title": "StorageManagementController",
        "fileName": "StorageManagementController.html",
        "text": "StorageManagementController : Controller for storageManagementContainer LWC. Signature public with sharing class StorageManagementController Author : Ben Learn StorageManagementController Methods invokeManualClean() Method to manually invoke storage cleaning. invokeManualClean() Method to manually invoke storage cleaning. Signature @AuraEnabled public static void invokeManualClean() Author Ben Learn | 03-13-2022"
    },
    {
        "title": "StorageManagementService",
        "fileName": "StorageManagementService.html",
        "text": "StorageManagementService : Service class containing methods to clear storage by deleting unused badges and debug logs created by the Trail Tracker app. Signature public with sharing class StorageManagementService Author : Ben Learn @last modified on  : 01-08-2023 @last modified by  : Ben Learn StorageManagementService Methods clean() Method to clean storage by removing unused badges, trails, debug logs, and trailmixes. clean() Method to clean storage by removing unused badges, trails, debug logs, and trailmixes. Signature public static List<String> clean() Author Ben Learn | 03-13-2022"
    },
    {
        "title": "StorageManagementServiceImplementation",
        "fileName": "StorageManagementServiceImplementation.html",
        "text": "StorageManagementServiceImplementation : Service class containing methods to clear storage by deleting unused badges and debug logs created by the Trail Tracker app. Signature public with sharing class StorageManagementServiceImplementation implements IStorageManagementService Author : Ben Learn @last modified on  : 03-04-2023 @last modified by  : Ben Learn StorageManagementServiceImplementation Methods clean() Method to clean storage by removing unused badges, trails, debug logs, and trailmixes. clean() Method to clean storage by removing unused badges, trails, debug logs, and trailmixes. Signature public List<String> clean() Author Ben Learn | 03-13-2022"
    },
    {
        "title": "StorageManagementServiceStub",
        "fileName": "StorageManagementServiceStub.html",
        "text": "StorageManagementServiceStub : Stub class for storage management service layer. Signature public with sharing class StorageManagementServiceStub implements IStorageManagementService Author : Ben Learn @last modified on  : 01-08-2023 @last modified by  : Ben Learn StorageManagementServiceStub Methods clean() clean() Signature public List<String> clean()"
    },
    {
        "title": "TaskListController",
        "fileName": "TaskListController.html",
        "text": "TaskListController : Apex controller for taskList LWC. Signature public with sharing class TaskListController Author : Ben Learn TaskListController Methods getTasks() Method to return all open tasks for taskList LWC. getTasks() Method to return all open tasks for taskList LWC. Signature @AuraEnabled(cacheable=true) public static List<Task> getTasks() Returns List<Task> Author Ben Learn | 03-11-2022"
    },
    {
        "title": "RecommendedBadgeMixTriggerHandler",
        "fileName": "RecommendedBadgeMixTriggerHandler.html",
        "text": "RecommendedBadgeMixTriggerHandler Trigger handler for Recommended_Badge_Mix__c custom object Signature public without sharing class RecommendedBadgeMixTriggerHandler extends TriggerHandler Author Ben Learn Since 01-29-2023 RecommendedBadgeMixTriggerHandler Constructors RecommendedBadgeMixTriggerHandler() RecommendedBadgeMixTriggerHandler() Signature public RecommendedBadgeMixTriggerHandler() RecommendedBadgeMixTriggerHandler Methods afterInsert(newRecordsMap) afterUpdate(updatedRecordsMap, oldRecordsMap) afterInsert(newRecordsMap) Signature protected override void afterInsert(Map<Id, sObject> newRecordsMap) afterUpdate(updatedRecordsMap, oldRecordsMap) Signature protected override void afterUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap) RecommendedBadgeMixTriggerHandler.MultipleDefaultBadgeMixException Validates that only one recommended badge mix is marked as a default. Throws a MultipleDefaultBadgeMixException if multiple are marked as defaults. Signature public class MultipleDefaultBadgeMixException extends Exception"
    },
    {
        "title": "RecommendedBadgeTriggerHandler",
        "fileName": "RecommendedBadgeTriggerHandler.html",
        "text": "RecommendedBadgeTriggerHandler Signature public without sharing class RecommendedBadgeTriggerHandler extends TriggerHandler RecommendedBadgeTriggerHandler Constructors RecommendedBadgeTriggerHandler() RecommendedBadgeTriggerHandler() Signature public RecommendedBadgeTriggerHandler() RecommendedBadgeTriggerHandler Methods beforeInsert(newRecords) beforeUpdate(updatedRecordsMap, oldRecordsMap) beforeInsert(newRecords) Signature protected override void beforeInsert(List<sObject> newRecords) beforeUpdate(updatedRecordsMap, oldRecordsMap) Signature protected override void beforeUpdate(Map<Id, sObject> updatedRecordsMap, Map<Id, sObject> oldRecordsMap)"
    },
    {
        "title": "RecommendedTrailTriggerHandler",
        "fileName": "RecommendedTrailTriggerHandler.html",
        "text": "RecommendedTrailTriggerHandler Signature public without sharing class RecommendedTrailTriggerHandler extends TriggerHandler RecommendedTrailTriggerHandler Constructors RecommendedTrailTriggerHandler() RecommendedTrailTriggerHandler() Signature public RecommendedTrailTriggerHandler()"
    }
];
