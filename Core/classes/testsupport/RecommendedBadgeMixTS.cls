@isTest
public class RecommendedBadgeMixTS extends TestSupport.DataGeneration {
    @SuppressWarnings('PMD.ApexDoc')
    public RecommendedBadgeMixTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    @SuppressWarnings('PMD.ApexDoc')
    public RecommendedBadgeMixTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'Recommended_Badge_Mix__c';
    }

    protected override Map<Schema.SObjectField, TestSupport.TestDataField> loadDefaultSpecsByField() {
        return new Map<Schema.SObjectField, TestSupport.TestDataField>{
            Recommended_Badge_Mix__c.Name => new CounterSuffixField(Recommended_Badge_Mix__c.Name, 'Test Mix '),
            Recommended_Badge_Mix__c.Private_Mix__c => new BooleanField(Recommended_Badge_Mix__c.Private_Mix__c)
        };
    }
}