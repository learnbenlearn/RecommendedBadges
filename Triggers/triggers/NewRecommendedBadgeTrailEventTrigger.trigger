trigger NewRecommendedBadgeTrailEventTrigger on NewRecommendedBadgeTrailEvent__e (after insert) {
    new NewRecommendedBadgeTrailEventTrgrHandler().execute();
}