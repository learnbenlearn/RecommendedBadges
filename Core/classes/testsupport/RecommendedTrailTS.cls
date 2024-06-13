@isTest
public class RecommendedTrailTS extends TestSupport.DataGeneration {
    public MixCategoryTS mixCategoryGenerator;

    @SuppressWarnings('PMD.ApexDoc')
    public RecommendedTrailTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    @SuppressWarnings('PMD.ApexDoc')
    public RecommendedTrailTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'Recommended_Trail__c';
        this.generateMasterRecords = Boolean.valueOf(options.get('generateMasterRecords') ?? true);
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField>{
            Recommended_Trail__c.TrailAPIName__c => new CounterSuffixField(Recommended_Trail__c.TrailAPIName__c, 'Test_Trail_')
        };
    }

    protected override Map<Schema.SObjectField, RelationshipField> loadMasterDetailFields() {
        this.mixCategoryGenerator = new MixCategoryTS(new Map<String, Object>{'numberToGenerate' => 100});
        return new Map<Schema.SObjectField, RelationshipField> {
            Recommended_Trail__c.Mix_Category__c => new RelationshipField(
                Recommended_Trail__c.Mix_Category__c, 
                new Map<Id, sObject>(this.mixCategoryGenerator.generate()).keySet()
            )
        };
    }
}