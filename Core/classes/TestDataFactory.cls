/**
 * @description       : Test data factory for the Recommended Badges application. Currently inserts data into the database, will likely be refactored to be used with
 *                      mocks in the future.
 * @author            : Ben Learn
 * @last modified on  : 02-20-2023
 * @last modified by  : Ben Learn
**/
@isTest
public class TestDataFactory {
    // lazy loaded static variable to hold possible Level picklist field values
    private static final List<String> badgeAndTrailLevels {
        get {
            if(badgeAndTrailLevels == null) {
                badgeAndTrailLevels = new List<String>();
                for(Schema.PicklistEntry pe : trailheadapp__Badge__c.trailheadapp__Level__c.getDescribe().getPicklistValues()) {
                    badgeAndTrailLevels.add(pe.getValue());
                }
            }
            return badgeAndTrailLevels;
        }
        set;
    }

    // lazy loaded static variable to hold possible Type picklist field values
    private static List<String> badgeTypes {
        get {
            if(badgeTypes == null) {
                badgeTypes = new List<String>();
                for(Schema.PicklistEntry pe : trailheadapp__Badge__c.trailheadapp__Type__c.getDescribe().getPicklistValues()) {
                    badgeTypes.add(pe.getValue());
                }
            }
            return badgeTypes;
        }
        set;
    }

    private static String getRandomLevel() {
        return badgeAndTrailLevels[Integer.valueOf(Math.floor(Math.random()*badgeAndTrailLevels.size()))];
    }

    private static String getRandomType() {
        return badgeTypes[Integer.valueOf(Math.floor(Math.random()*badgeTypes.size()))];
    }

    public interface RecordGeneration {
        List<sObject> execute();
    }

    // abstract class to hold flags for execute methods of RecordGeneration implementations
    public abstract class RecordGenerationTemplate {
        public final Boolean INSERT_RECORDS;
        public final Boolean RETURN_CREATED_RECORDS;
        public final Integer NUMBER_TO_GENERATE;

        public RecordGenerationTemplate(Boolean insertRecords, Boolean returnCreatedRecords) {
            this(insertRecords, returnCreatedRecords, 200);
        }

        public RecordGenerationTemplate(Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate) {
            this.INSERT_RECORDS = insertRecords;
            this.RETURN_CREATED_RECORDS = returnCreatedRecords;
            this.NUMBER_TO_GENERATE = numberToGenerate;
        }
    }

    public class Badge extends RecordGenerationTemplate implements RecordGeneration {
        public final Boolean INCLUDE_ARCHIVED_BADGES;
        public final Boolean INCLUDE_BADGE_PRODUCTS;
        public final Boolean INCLUDE_BADGES_TO_KEEP;
        public final List<String> BADGE_PRODUCTS;
        public final List<String> BADGES_TO_KEEP;

        public Badge(Boolean insertRecords, Boolean returnCreatedRecords) {
            this(insertRecords, returnCreatedRecords, false, false, false, null, null);
        }

        public Badge(
            Boolean insertRecords, Boolean returnCreatedRecords, Boolean includeArchivedBadges, Boolean includeBadgeProducts, Boolean includeBadgesToKeep, 
            List<String> badgeProducts, List<String> badgesToKeep
        ) {
            super(insertRecords, returnCreatedRecords);
            this.INCLUDE_ARCHIVED_BADGES = includeArchivedBadges;
            this.INCLUDE_BADGE_PRODUCTS = includeBadgeProducts;
            this.INCLUDE_BADGES_TO_KEEP = includeBadgesToKeep;
            this.BADGE_PRODUCTS = badgeProducts;
            this.BADGES_TO_KEEP = badgesToKeep;
        }

        public List<sObject> execute() {
            List<trailheadapp__Badge__c> testBadges = new List<trailheadapp__Badge__c>();

            Boolean archived = false;
            for(Integer i = 0; i < this.NUMBER_TO_GENERATE; i++) {
                testBadges.add(new trailheadapp__Badge__c(
                    Name='Test Badge ' + i,
                    trailheadapp__Level__c=getRandomLevel(),
                    trailheadapp__Type__c=getRandomType(),
                    trailheadapp__API_Name__c='Test_Badge_' + i,
                    trailheadapp__Description__c='Test Description',
                    trailheadapp__Namespace__c='Test Namespace',
                    trailheadapp__URL__c='www.test.com',
                    trailheadapp__Icon__c='www.testicon.com',
                    trailheadapp__Archived__c=this.INCLUDE_ARCHIVED_BADGES ? archived : false
                ));
                if(this.INCLUDE_ARCHIVED_BADGES) archived = !archived;
            }

            if(this.INCLUDE_BADGE_PRODUCTS) {
                for(String badgeProduct : this.BADGE_PRODUCTS) {
                    testBadges.add(new trailheadapp__Badge__c(
                        Name=badgeProduct + ' Badge',
                        trailheadapp__Level__c=getRandomLevel(),
                        trailheadapp__Type__c=getRandomType(),
                        trailheadapp__API_Name__c=badgeProduct + ' Badge',
                        trailheadapp__Description__c='Test Description',
                        trailheadapp__Namespace__c='Test Namespace',
                        trailheadapp__URL__c='www.test.com',
                        trailheadapp__Icon__c='www.testicon.com',
                        trailheadapp__Products__c=badgeProduct
                    ));
                }
            }

            if(this.INCLUDE_BADGES_TO_KEEP) {
                for(String badgeToKeep : this.BADGES_TO_KEEP) {
                    testBadges.add(new trailheadapp__Badge__c(
                        Name=badgeToKeep,
                        trailheadapp__Level__c=getRandomLevel(),
                        trailheadapp__Type__c=getRandomType(),
                        trailheadapp__API_Name__c=badgeToKeep,
                        trailheadapp__Description__c='Test Description',
                        trailheadapp__Namespace__c='Test Namespace',
                        trailheadapp__URL__c='www.test.com',
                        trailheadapp__Icon__c='www.testicon.com'
                    ));
                }
            }

            if(this.INSERT_RECORDS) insert testBadges;
            return this.RETURN_CREATED_RECORDS ? testBadges : null;
        }
    }

    public class DebugLog extends RecordGenerationTemplate implements RecordGeneration {
        public DebugLog(Boolean insertRecords, Boolean returnCreatedRecords) {
            super(insertRecords, returnCreatedRecords);
        }

        public List<sObject> execute() {
            List<trailheadapp__Debug_Log__c> testDebugLogs = new List<trailheadapp__Debug_Log__c>();
            for(Integer i = 0; i < this.NUMBER_TO_GENERATE; i++) {
                testDebugLogs.add(new trailheadapp__Debug_Log__c(
                    trailheadapp__Class__c='Test ' + i,
                    trailheadapp__Datetime__c=DateTime.now(),
                    trailheadapp__Message__c='Test Message ' + i,
                    trailheadapp__Method__c='Test Method ' + i,
                    trailheadapp__Severity__c='Test ' + i,
                    trailheadapp__Transaction__c='Test Transaction ' + i
                ));
            }
            
            if(this.INSERT_RECORDS) insert testDebugLogs;
            return this.RETURN_CREATED_RECORDS ? testDebugLogs : null;
        }
    }

    public class MixCategory extends RecordGenerationTemplate implements RecordGeneration {
        public final List<Recommended_Badge_Mix__c> RECOMMENDED_BADGE_MIXES;

        public MixCategory(Boolean insertRecords, Boolean returnCreatedRecords, List<Recommended_Badge_Mix__c> recommendedBadgeMixes) {
            this(insertRecords, returnCreatedRecords, 4, recommendedBadgeMixes);
        }

        public MixCategory(Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate, List<Recommended_Badge_Mix__c> recommendedBadgeMixes) {
            super(insertRecords, returnCreatedRecords, numberToGenerate);
            this.RECOMMENDED_BADGE_MIXES = recommendedBadgeMixes;
        }

        public List<sObject> execute() {
            List<Mix_Category__c> testMixCategories = new List<Mix_Category__c>();

            for(Integer i = 0; i < this.NUMBER_TO_GENERATE; i++) {
                testMixCategories.add(new Mix_Category__c(
                    Name = this.RECOMMENDED_BADGE_MIXES[Math.mod(i, RECOMMENDED_BADGE_MIXES.size())].Name + ' Category ' + i,
                    Recommended_Badge_Mix__c = this.RECOMMENDED_BADGE_MIXES[Math.mod(i, RECOMMENDED_BADGE_MIXES.size())].Id
                ));
            }

            if(this.INSERT_RECORDS) insert testMixCategories;
            return this.RETURN_CREATED_RECORDS ? testMixCategories : null;
        }
    }

    public class RecommendedBadge extends RecordGenerationTemplate implements RecordGeneration {
        public final Boolean BYPASS_DUPLICATE_RULES;
        public final List<trailheadapp__Badge__c> BADGES;
        public final List<Mix_Category__c> MIX_CATEGORIES;

        public RecommendedBadge(
            Boolean insertRecords, Boolean returnCreatedRecords, List<trailheadapp__Badge__c> badges, List<Mix_Category__c> mixCategories, Boolean bypassDuplicateRules
        ) {
            super(insertRecords, returnCreatedRecords);
            this.BADGES = badges;
            this.MIX_CATEGORIES = mixCategories;
            this.BYPASS_DUPLICATE_RULES = bypassDuplicateRules;
        }

        public RecommendedBadge(
            Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate, List<trailheadapp__Badge__c> badges, List<Mix_Category__c> mixCategories, 
            Boolean bypassDuplicateRules
        ) {
            super(insertRecords, returnCreatedRecords, numberToGenerate);
            this.BADGES = badges;
            this.MIX_CATEGORIES = mixCategories;
            this.BYPASS_DUPLICATE_RULES = bypassDuplicateRules;
        }

        public List<sObject> execute() {
            List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();

            for(Integer i = 0; i < this.NUMBER_TO_GENERATE; i++) {
                if(Math.mod(i, 10) == 0) {
                    testRecommendedBadges.add(new Recommended_Badge__c(
                        Mix_Category__c=MIX_CATEGORIES[Integer.valueOf(Math.floor(Math.mod(i, MIX_CATEGORIES.size())))].Id,
                        BadgeAPIName__c=BADGES[i].trailheadapp__API_Name__c,
                        Badge__c=BADGES[i].Id,
                        High_Priority__c=true
                    ));
                } else {
                    testRecommendedBadges.add(new Recommended_Badge__c(
                        Mix_Category__c=MIX_CATEGORIES[Integer.valueOf(Math.floor(Math.mod(i, MIX_CATEGORIES.size())))].Id,
                        BadgeAPIName__c=BADGES[i].trailheadapp__API_Name__c,
                        Badge__c=BADGES[i].Id
                    ));
                }
            }

            if(this.INSERT_RECORDS) {
                Database.DMLOptions dmlOptions = new Database.DMLOptions();
                dmlOptions.DuplicateRuleHeader.allowSave = this.BYPASS_DUPLICATE_RULES;
                Database.insert(testRecommendedBadges, dmlOptions);
            }

            return this.RETURN_CREATED_RECORDS ? testRecommendedBadges : null;
        }
    }

    public class RecommendedBadgeMix extends RecordGenerationTemplate implements RecordGeneration {
        public final Boolean INCLUDE_DEFAULT_MIX;
        public final Boolean BYPASS_DUPLICATE_RULES;

        public RecommendedBadgeMix(Boolean insertRecords, Boolean returnCreatedRecords) {
            this(insertRecords, returnCreatedRecords, 10, false, true);
        }

        public RecommendedBadgeMix(Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate, Boolean includeDefaultMix, Boolean bypassDuplicateRules) {
            super(insertRecords, returnCreatedRecords, numberToGenerate);
            this.INCLUDE_DEFAULT_MIX = includeDefaultMix;
            this.BYPASS_DUPLICATE_RULES = bypassDuplicateRules;
        }

        public List<sObject> execute() {
            List<Recommended_Badge_Mix__c> testRecommendedBadgeMixes = new List<Recommended_Badge_Mix__c>();
            Boolean privateMix = false;

            for(Integer i = 0; i < this.NUMBER_TO_GENERATE; i++) {
                if(i == 0 && this.INCLUDE_DEFAULT_MIX) {        
                    testRecommendedBadgeMixes.add(new Recommended_Badge_Mix__c(
                        Name = 'Test Mix ' + i,
                        Private_Mix__c = privateMix,
                        Default_Badge_Mix__c = true
                    ));
                } else {
                    testRecommendedBadgeMixes.add(new Recommended_Badge_Mix__c(
                        Name = 'Test Mix ' + i,
                        Private_Mix__c = privateMix
                    ));
                }
                privateMix = !privateMix;
            }

            if(this.INSERT_RECORDS) {
                Database.DMLOptions dmlOptions = new Database.DMLOptions();
                dmlOptions.DuplicateRuleHeader.allowSave = this.BYPASS_DUPLICATE_RULES;
                Database.insert(testRecommendedBadgeMixes, dmlOptions);
            }
            
            return this.RETURN_CREATED_RECORDS ? testRecommendedBadgeMixes : null;
        }
    }

    public class RecommendedTrail extends RecordGenerationTemplate implements RecordGeneration {
        public final Boolean BYPASS_DUPLICATE_RULES;
        public final List<trailheadapp__Trail__c> TRAILS;
        public final List<Mix_Category__c> MIX_CATEGORIES;

        public RecommendedTrail(
            Boolean insertRecords, Boolean returnCreatedRecords, List<trailheadapp__Trail__c> trails, List<Mix_Category__c> mixCategories, Boolean bypassDuplicateRules
        ) {
            super(insertRecords, returnCreatedRecords);
            this.TRAILS = trails;
            this.MIX_CATEGORIES = mixCategories;
            this.BYPASS_DUPLICATE_RULES = bypassDuplicateRules;
        }

        public RecommendedTrail(
            Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate, List<trailheadapp__Trail__c> trails, List<Mix_Category__c> mixCategories, 
            Boolean bypassDuplicateRules
        ) {
            super(insertRecords, returnCreatedRecords, numberToGenerate);
            this.TRAILS = trails;
            this.MIX_CATEGORIES = mixCategories;
            this.BYPASS_DUPLICATE_RULES = bypassDuplicateRules;
        }

        public List<sObject> execute() {
            List<Recommended_Trail__c> testRecommendedTrails = new List<Recommended_Trail__c>();
            for(Integer i = 0; i < this.NUMBER_TO_GENERATE; i++) {
                testRecommendedTrails.add(new Recommended_Trail__c(
                    Mix_Category__c=MIX_CATEGORIES[Integer.valueOf(Math.floor(MIX_CATEGORIES.size()/10))].Id,
                    Trail__c=TRAILS[i].Id
                ));
            }

            if(this.INSERT_RECORDS) {
                Database.DMLOptions dmlOptions = new Database.DMLOptions();
                dmlOptions.DuplicateRuleHeader.allowSave = this.BYPASS_DUPLICATE_RULES;
                Database.insert(testRecommendedTrails, dmlOptions);
            }

            return this.RETURN_CREATED_RECORDS ? testRecommendedTrails : null;
        }
    }

    public class Task extends RecordGenerationTemplate implements RecordGeneration {
        public Task(Boolean insertRecords, Boolean returnCreatedRecords) {
            super(insertRecords, returnCreatedRecords);
        }

        public Task(Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate) {
            super(insertRecords, returnCreatedRecords, numberToGenerate);
        }

        public List<sObject> execute() {
            List<Schema.Task> testTasks = new List<Schema.Task>();

            for(Integer i = 0; i < this.NUMBER_TO_GENERATE; i++) {
                if(Math.mod(i, 2) == 0) {
                    testTasks.add(new Schema.Task(Status='Not Started'));
                } else {
                    testTasks.add(new Schema.Task(Status='Completed'));
                }
            }

            if(this.INSERT_RECORDS) insert testTasks;
            return this.RETURN_CREATED_RECORDS ? testTasks : null;
        }
    }

    public class Trail extends RecordGenerationTemplate implements RecordGeneration {
        public final Boolean INCLUDE_ARCHIVED_TRAILS;
        public final Boolean INCLUDE_TRAIL_PRODUCTS;
        public final List<String> TRAIL_PRODUCTS;

        public Trail(Boolean insertRecords, Boolean returnCreatedRecords) {
            this(insertRecords, returnCreatedRecords, false, false, null);
        }

        public Trail(Boolean insertRecords, Boolean returnCreatedRecords, Boolean includeArchivedTrails, Boolean includeTrailProducts, List<String> trailProducts) {
            super(insertRecords, returnCreatedRecords);
            this.INCLUDE_ARCHIVED_TRAILS = includeArchivedTrails;
            this.INCLUDE_TRAIL_PRODUCTS = includeTrailProducts;
            this.TRAIL_PRODUCTS = trailProducts;
        }

        public List<sObject> execute() {
            List<trailheadapp__Trail__c> testTrails = new List<trailheadapp__Trail__c>();
            Boolean archived = false;

            for(Integer i = 0; i < this.NUMBER_TO_GENERATE; i++) {
                testTrails.add(new trailheadapp__Trail__c(
                    Name='Test Trail ' + i,
                    trailheadapp__Level__c=getRandomLevel(),
                    trailheadapp__API_Name__c='Test_Trail_' + i,
                    trailheadapp__Description__c='Test Description',
                    trailheadapp__Namespace__c='Test Namespace',
                    trailheadapp__URL__c='www.test.com',
                    trailheadapp__Icon__c='www.testicon.com',
                    trailheadapp__Archived__c = this.INCLUDE_ARCHIVED_TRAILS ? archived : false
                ));
                if(this.INCLUDE_ARCHIVED_TRAILS) archived = !archived;
            }

            if(this.INCLUDE_TRAIL_PRODUCTS) {
                for(String trailProduct : this.TRAIL_PRODUCTS) {
                    testTrails.add(new trailheadapp__Trail__c( 
                        Name = trailProduct + ' Trail ',
                        trailheadapp__API_Name__c = trailProduct + ' Trail ',
                        trailheadapp__Products__c = trailProduct
                    ));
                }
            }

            if(this.INSERT_RECORDS) insert testTrails;
            return this.RETURN_CREATED_RECORDS ? testTrails : null;
        }
    }

    public class Trailmix extends RecordGenerationTemplate implements RecordGeneration {
        public Trailmix(Boolean insertRecords, Boolean returnCreatedRecords) {
            super(insertRecords, returnCreatedRecords);
        }

        public List<sObject> execute() {
            List<trailheadapp__Trailmix__c> testTrailmixes = new List<trailheadapp__Trailmix__c>();

            for(Integer i = 0; i < this.NUMBER_TO_GENERATE; i++) {
                testTrailmixes.add(new trailheadapp__Trailmix__c(
                    Name='Test Trailmix ' + i,
                    trailheadapp__Created_By_Profile__c='www.test.com',
                    trailheadapp__External_Id__c='Test Trailmix ' + i,
                    trailheadapp__Slug__c='Test_Trailmix_' + i,
                    trailheadapp__URL__c='www.test.com'
                ));
            }
            
            if(this.INSERT_RECORDS) insert testTrailmixes;
            return this.RETURN_CREATED_RECORDS ? testTrailmixes : null;
        }
    }

    public class UserBadge extends RecordGenerationTemplate implements RecordGeneration {
        public final List<trailheadapp__Badge__c> BADGES;

        public UserBadge(Boolean insertRecords, Boolean returnCreatedRecords, List<trailheadapp__Badge__c> badges) {
            super(insertRecords, returnCreatedRecords);
            this.BADGES = badges;
        }

        public List<sObject> execute() {
            List<User> users = [SELECT Id FROM User];
            List<trailheadapp__User_Badge__c> testUserBadges = new List<trailheadapp__User_Badge__c>();
            for(trailheadapp__Badge__c badge : this.BADGES) {
                testUserBadges.add(new trailheadapp__User_Badge__c(
                    trailheadapp__Badge__c=badge.Id,
                    trailheadapp__User__c=users[0].Id
                ));
            }
            
            if(this.INSERT_RECORDS) insert testUserBadges;

            return this.RETURN_CREATED_RECORDS ? testUserBadges : null;
        }
    }
}