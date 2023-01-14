# Recommended Badges

## Test Runtimes

<details>

| Test Class                         | Test Method                                                    | Runtime (s) |
| ---------------------------------- | -------------------------------------------------------------- | ----------- |
| BensViewControllerTests            | getBensMixRecommendedBadges_test                               | 2.924       |
|                                    | getMixCategoryData_test                                        | 0.322       |
| RecommendedBadgeMixControllerTests |  getSetupData_testDefaultBadgeMix                              | 0.281       |
|                                    | getSetupData_testNoDefaultBadgeMix                             | 0.222       |
| SortCustomMetadataControllerTests  | getSortOptions_test                                            | 0.056       |
| StorageManagementServiceTests      | manualClean_test                                               | 28.989      |
| TaskListControllerTests            | testGetTasks                                                   | 0.061       |
|                                    | testGetTasksRestrictiedUser                                    | 0.738       |
| BadgeTrigger_HelperTests           | testCreateCMTDeleteTasks_bulk                                  | 5.618       |
|                                    | testCreateCMTDeleteTasks_singleNegative                        | 0.458       |
|                                    | testCreateCMTDeleteTasks_singlePositive                        | 0.707       |
|                                    | testPopulateBadgeMixKeys_bulkNegativeInsert                    | 0.973       |
|                                    | testPopulateBadgeMixKeys_bulkPositiveInsert                    | 0.869       |
|                                    | testPopulateBadgeMixKeys_bulkPositiveUpdate                    | 2.206       |
|                                    | testPopulateBadgeMixKeys_negativeBulkUpdate                    | 7.656       |
|                                    | testPopulateBadgeMixKeys_negativeInsert                        | 0.498       |
|                                    | testPopulateBadgeMixKeys_negativeUpdate                        | 0.521       |
|                                    | testPopulateBadgeMixKeys_singlePositiveInsert                  | 0.395       |
|                                    | testPopulateBadgeMixKeys_singlePositiveUpdate                  | 0.462       |
|                                    | testPopulateJunctionPicklists_bulkBadges                       | 1.034       |
|                                    | testPopulateJunctionPicklists_bulkBadgesNegative               | 0.926       |
|                                    | testPopulateJunctionPicklists_bullkTrails                      | 0.694       |
|                                    | testPopulateJunctionPicklists_bulkTrailsNegative               | 0.776       |
|                                    | testPopulateJunctionPicklists_singleBadge                      | 0.223       |
|                                    | testPopulateJunctionPicklists_singleBadgeNegative              | 0.134       |
|                                    | testPopulateJunctionPicklists_singleTrail                      | 0.134       |
|                                    | testPopulateJunctionPicklists_singleTrailNegative              | 0.123       |
|                                    | testUpdateJunctionTypesAndLevels_bulkBadges                    | 3.496       |
|                                    | testUpdateJunctionTypesAndLevels_bulkBadgesNegative            | 2.262       |    
|                                    | testUpdateJunctionTypesAndLevels_bulkTrails                    | 2.839       |
|                                    | testUpdateJunctionTypesAndLevels_bulkTrailsNegative            | 1.995       |
|                                    | testUpdateJunctionTypesAndLevels_singleBadgeLevelChange        | 1.822       |
|                                    | testUpdateJunctionTypesAndLevels_singleBadgeNegative           | 2.463       |
|                                    | testUpdateJunctionTypesAndLevels_singleBadgeTypeAndLevelChange | 1.913       |
|                                    | testUpdateJunctionTypesAndLevels_singleBadgeTypeChange         | 2.172       |
|                                    | testUpdateJunctionTypesAndLevels_singleTrail                   | 1.523       |
|                                    | testUpdateJunctionTypesAndLevels_singleTrailNegative           | 1.762       |
|                                    | testEnforceSingleDefaultMix_insertBulkPositive                 | 0.506       |
|                                    | testEnforceSingleDefaultMix_insertNegative                     | 0.028       |
|                                    | testEnforceSingleDefaultMix_insertNoDefault                    | 0.020       |
|                                    | testEnforceSingleDefaultMix_insertPositive                     | 0.022       |
|                                    | testEnforceSingleDefaultMix_updateNegative                     | 0.081       |
|                                    | testEnforceSingleDefaultMix_updateNegativeBulk                 | 1.744       |
|                                    | testEnforceSingleDefaultMix_updateNoDefault                    | 0.040       |
|                                    | testEnforceSingleDefaultMix_updateNoDefaultBulk                | 1.667       |
|                                    | testEnforceSingleDefaultMix_updatePositive                     | 0.045       |    
|                                    | testEnforceSingleDefaultMix_updatePositiveBulk                 | 1.593       |
|                                    | testEnforceSingleDefaultMix_insertBulkNegative                 | 1.360       |
|                                    | testEnforcesingleDefaultMix_insertBulkNoDefault                | 0.730       |

</details>

## Test Coverage

<details>

| Class                             | Coverage |
| --------------------------------- | -------- |
| BadgeTrigger                      | 100%     |
| BadgeTrigger_Helper               | 100%     |
| BensViewController                | 100%     |
| MultipleDefaultBadgeMixException  | 0%       |
| RecommendedBadgeMixController     | 100%     |
| RecommendedBadgeMixTrigger        | 100%     |
| RecommendedBadgeMixTrigger_Helper | 100%     |
| RecommendedBadgeTrigger           | 100%     |
| RecommendedTrailTrigger           | 100%     |
| SetupDataWrapper                  | 100%     |
| SortCustomMetadataController      | 100%     |
| StorageLimitsController           | 100%     |
| StorageManagementController       | 97%      |
| TaskListController                | 100%     |
| TrailTrigger                      | 100%     |

</details>
