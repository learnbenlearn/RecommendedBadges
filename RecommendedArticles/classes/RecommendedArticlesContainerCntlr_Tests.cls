@isTest
private class RecommendedArticlesContainerCntlr_Tests {
    @testSetup
    private static void generateData() {       
        TopicTS topicGenerator = new TopicTS(new Map<String, Object>{'numberToGenerate' => 19, 'generateRecordIDs' => false});
        insert topicGenerator.generate();
    }

    private static User generateUser() {
        User u = TestSupport.generateTestUser('test', 'test@test.com', 'TestName', 'System Administrator', 'test@aol.fake.com');
        insert u;
        PermissionSet corePermissions = [SELECT Id FROM PermissionSet WHERE Name = 'Core_Permissions'];
        insert new PermissionSetAssignment(AssigneeId = u.Id, PermissionSetId = corePermissions.Id);
        return u;
    }

    private static List<Topic> generateTopics() {
        TopicTS topicGenerator = new TopicTS(new Map<String, Object>{'numberToGenerate' => 19});
        return (List<Topic>) topicGenerator.generate();
    }

    @isTest
    private static void getRecommendedArticles_test() {
        /*Mock recommendedArticlesSelectorMock = Mock.forType(RecommendedArticlesSelector.class);
        RecommendedArticlesSelector recommendedArticlesSelectorStub = (RecommendedArticlesSelector) recommendedArticlesSelectorMock.stub;
        MethodSpy selectAllWithTopicsSpy = recommendedArticlesSelectorMock.spyOn('selectAllWithTopics');

        RecommendedArticleTS articleGenerator = new RecommendedArticleTS(new Map<String, Object>{'numberToGenerate' => 100});
        Map<Id, RecommendedArticle__c> articleMap = new Map<Id, RecommendedArticle__c>((List<RecommendedArticle__c>) articleGenerator.generate());
        Map<Id, Topic> topicMap = new Map<Id, Topic>(generateTopics());
        TopicAssignmentTS topicAssignmentGenerator = new TopicAssignmentTS(
            new Map<String, Object>(),
            new List<TestSupport.TestDataField>{
                new RelationshipField(TopicAssignment.TopicId, topicMap.keySet()),
                new RelationshipField(TopicAssignment.EntityId, articleMap.keySet())
            }
        );
        List<TopicAssignment> topicAssignments = (List<TopicAssignment>) topicAssignmentGenerator.generate();
        

        Map<Id, List<TopicAssignment>> topicAssignmentsByArticleId = new Map<Id, List<TopicAssignment>>();
        List<TopicAssignment> tempTopicAssignments;
        
        for(TopicAssignment ta : topicAssignments) {
            ta.Topic = topicMap.get(ta.TopicId);
            System.debug(JSON.serialize(ta));
        }*/
        
        
        /*for(TopicAssignment ta : topicAssignments) {
            if(topicAssignmentsByArticleId.containsKey(ta.EntityId)) {
                tempTopicAssignments = topicAssignmentsByArticleId.get(ta.EntityId);
                tempTopicAssignments.add(ta);
                topicAssignmentsByArticleId.put(ta.EntityId, tempTopicAssignments);
            } else {
                topicAssignmentsByArticleId.put(ta.EntityId, new List<TopicAssignment>{ta});
            }
        }
          

        List<RecommendedArticle__c> expectedArticles = new List<RecommendedArticle__c>();*/
        // serialize, then strip 1st and last characters, then add topic assignments and deserialize
        // does order matter? is it more efficient to serialize List<RecommendedArticle__c> or iterate through list and serialize each RecommendedArticle__c one at a time?
        /*for(RecommendedArticle__c ra : articleMap.values()) {
            String serializedArticle = JSON.serialize(ra).substring(1, JSON.serialize(ra).length() - 1);
            String serializedTopicAssignments = JSON.serialize(topicAssignmentsByArticleId.get(ra.Id));
            RecommendedArticle__c expectedRA = (RecommendedArticle__c) JSON.deserialize(
                '{' + serializedArticle + ', "TopicAssignments": {"totalSize": ' + topicAssignmentsByArticleId.get(ra.Id).size() + ', "done": true, "records": ' + serializedTopicAssignments + '}}',
                RecommendedArticle__c.class
            );
            expectedArticles.add(ra);
        }
        
        selectAllWithTopicsSpy.returns(expectedArticles);*/
        /*System.runAs(generateUser()) {
            RecommendedArticleTS articleGenerator = new RecommendedArticleTS(new Map<String, Object>{'numberToGenerate' => 100, 'generateRecordIDs' => false});
            insert articleGenerator.generate();
            Map<Id, RecommendedArticle__c> articleMap = new Map<Id, RecommendedArticle__c>((List<RecommendedArticle__c>) articleGenerator.records);

            TopicAssignmentTS topicAssignmentGenerator = new TopicAssignmentTS(
                new Map<String, Object>{'generateRecordIDs' => false},
                new List<TestSupport.TestDataField>{
                    new RelationshipField(TopicAssignment.TopicId, (new Map<Id, Topic>([SELECT Id FROM Topic])).keySet()),
                    new RelationshipField(TopicAssignment.EntityId, articleMap.keySet())
                }
            );
            insert topicAssignmentGenerator.generate();
*/
        //Map<Id, TopicAssignment> topicAssignmentMap = new Map<Id, TopicAssignment>(topicAssignments);

        Test.startTest();
        List<RecommendedArticle__c> actualArticles = RecommendedArticlesContainerController.getRecommendedArticles();
        Test.stopTest();
        
        //Expect.that(selectAllWithTopicsSpy).hasBeenCalledTimes(1);
        /*Assert.areEqual((new Map<Id, RecommendedArticle__c>(expectedArticles)).keySet(), (new Map<Id, RecommendedArticle__c>(actualArticles)).keySet(), 'Expected all recommended articles to be returned.');
        for(RecommendedArticle__c a : actualArticles) {
            for(TopicAssignment ta : a.TopicAssignments) {
                Assert.areEqual(topicAssignmentMap.get(ta.Id).EntityId, a.Id, 'Expected Topic Assignment to be related to current Recommended Article.');
            }
        }*/
    }

    @isTest
    private static void getTopics_test() {
        System.runAs(generateUser()) {
            RecommendedArticleTS articleGenerator = new RecommendedArticleTS(new Map<String, Object>{'numberToGenerate' => 100, 'generateRecordIDs' => false});
            insert articleGenerator.generate();

            TopicAssignmentTS topicAssignmentGenerator = new TopicAssignmentTS(
                new Map<String, Object>{'generateRecordIDs' => false},
                new List<TestSupport.TestDataField>{
                    new RelationshipField(TopicAssignment.TopicId, (new Map<Id, Topic>([SELECT Id FROM Topic])).keySet()),
                    new RelationshipField(TopicAssignment.EntityId, (new Map<Id, RecommendedArticle__c>((List<RecommendedArticle__c>) articleGenerator.records)).keySet())
                }
            );
            insert topicAssignmentGenerator.generate();

            List<TopicAssignment> topicAssignments = [SELECT Id, TopicId, EntityId, Topic.Name FROM TopicAssignment];
            for(TopicAssignment ta : topicAssignments) {
                System.debug(JSON.serialize(ta));
            }

            Test.startTest();
            List<Topic> actualTopics = RecommendedArticlesContainerController.getTopics();
            Test.stopTest();
            
            Assert.areEqual(new Set<Topic>([SELECT Id, Name FROM Topic]), new Set<Topic>(actualTopics), 'Expected Topics tagging Recommended Articles to be returned.');
        }
    }
}