/**
 * Apex controller for recommendedArticlesContainer component
 * @author Ben Learn
 * @since 08-05-2024
 */
public with sharing class RecommendedArticlesController {
    @AuraEnabled(cacheable=true)
    public static List<RecommendedArticle__c> getRecommendedArticles() {
        List<RecommendedArticle__c> articles = [SELECT Id, Name, Title__c, URL__c, (SELECT Id, Topic.Name FROM TopicAssignments) FROM RecommendedArticle__c];
        return articles;
    }

    @AuraEnabled(cacheable=true)
    public static List<Topic> getTopics() {
        return [SELECT Name FROM Topic ORDER BY Name];
    }
}