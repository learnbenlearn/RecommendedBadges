/**
 * @description       : Test data factory for the Recommended Badges application. Currently inserts data into the database, will likely be refactored to be used with
 *                      mocks in the future.
 * @author            : Ben Learn
 * @last modified on  : 02-20-2023
 * @last modified by  : Ben Learn
**/
@isTest
public class TestDataFactory {
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
        public final List<Mix_Category__c> MIX_CATEGORIES;

        public RecommendedBadge(
            Boolean insertRecords, Boolean returnCreatedRecords, List<Mix_Category__c> mixCategories, Boolean bypassDuplicateRules
        ) {
            super(insertRecords, returnCreatedRecords);
            this.MIX_CATEGORIES = mixCategories;
            this.BYPASS_DUPLICATE_RULES = bypassDuplicateRules;
        }

        public RecommendedBadge(
            Boolean insertRecords, Boolean returnCreatedRecords, Integer numberToGenerate, List<Mix_Category__c> mixCategories, 
            Boolean bypassDuplicateRules
        ) {
            super(insertRecords, returnCreatedRecords, numberToGenerate);
            this.MIX_CATEGORIES = mixCategories;
            this.BYPASS_DUPLICATE_RULES = bypassDuplicateRules;
        }

        public List<sObject> execute() {
            List<Recommended_Badge__c> testRecommendedBadges = new List<Recommended_Badge__c>();

            for(Integer i = 0; i < this.NUMBER_TO_GENERATE; i++) {
                if(Math.mod(i, 10) == 0) {
                    testRecommendedBadges.add(new Recommended_Badge__c(
                        BadgeAPIName__c='Test_Badge_' + i,
                        Mix_Category__c=MIX_CATEGORIES[Integer.valueOf(Math.floor(Math.mod(i, MIX_CATEGORIES.size())))].Id,
                        High_Priority__c=true
                    ));
                } else {
                    testRecommendedBadges.add(new Recommended_Badge__c(
                        BadgeAPIName__c='Test_Badge_' + i,
                        Mix_Category__c=MIX_CATEGORIES[Integer.valueOf(Math.floor(Math.mod(i, MIX_CATEGORIES.size())))].Id
                    ));
                }
            }

            if(this.INSERT_RECORDS) {
                Database.DMLOptions dmlOptions = new Database.DMLOptions();
                dmlOptions.DuplicateRuleHeader.allowSave = this.BYPASS_DUPLICATE_RULES;
                List<Database.SaveResult> saveResults = Database.insert(testRecommendedBadges, dmlOptions);
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
}