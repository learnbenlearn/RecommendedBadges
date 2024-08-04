%dw 2.4
input payload application/apex
output application/apex
---
payload map(record) -> {
  Id: record.Id,
  Name: if(record.Type__c != null) record.BadgeName__c else record.TrailName__c,
  Level: record.Level__c,
  Type: record.Type__c default "Trail",
  URL: record.URL__c
} as Object {class: "RecommendedBadgeMixController.MixCategoryChild"}
