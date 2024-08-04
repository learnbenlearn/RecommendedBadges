%dw 2.4
input payload application/json
output application/apex
---
payload.records map(record) -> {
    Id: record.trailheadapp__API_Name__c,
    Name: record.Name,
    SecondaryFieldValue: record.trailheadapp__API_Name__c
} as Object {class: "TrailheadEntityFormController.LookupItem"}