@isTest
public class NewRecommendedBadgeTrailEventTS extends TestSupport.DataGeneration {
    @SuppressWarnings('PMD.ApexDoc')
    public NewRecommendedBadgeTrailEventTS(Map<String, Object> options) {
        this(options, new List<TestSupport.TestDataField>());
    }

    @SuppressWarnings('PMD.ApexDoc')
    public NewRecommendedBadgeTrailEventTS(Map<String, Object> options, List<TestSupport.TestDataField> fieldSpecs) {
        super(options, fieldSpecs);
        this.S_OBJECT_TYPE = 'NewRecommendedBadgeTrailEvent__e';
        this.useFieldDefaults = false;
    }
}