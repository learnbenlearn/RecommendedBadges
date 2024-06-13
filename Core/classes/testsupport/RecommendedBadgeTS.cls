@isTest
public class RecommendedBadgeTS extends TestSupport.DataGeneration {
    public MixCategoryTS mixCategoryGenerator;

    @SuppressWarnings('PMD.ApexDoc')
    public RecommendedBadgeTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    @SuppressWarnings('PMD.ApexDoc')
    public RecommendedBadgeTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'Recommended_Badge__c';
        this.generateMasterRecords = Boolean.valueOf(options.get('generateMasterRecords') ?? true);
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField>{
            Recommended_Badge__c.BadgeAPIName__c => new CounterSuffixField(Recommended_Badge__c.BadgeAPIName__c, 'Test_Badge_')
        };
    }

    protected override Map<Schema.SObjectField, RelationshipField> loadMasterDetailFields() {
        this.mixCategoryGenerator = new MixCategoryTS(new Map<String, Object>{'numberToGenerate' => 100});
        return new Map<Schema.SObjectField, RelationshipField> {
            Recommended_Badge__c.Mix_Category__c => new RelationshipField(
                Recommended_Badge__c.Mix_Category__c, new Map<Id, sObject>(this.mixCategoryGenerator.generate()).keySet()
            )
        };
    }
}