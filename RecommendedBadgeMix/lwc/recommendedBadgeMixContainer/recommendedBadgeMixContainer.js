/* eslint-disable sort-imports, one-var, @lwc/lwc/no-for-of, no-underscore-dangle, no-ternary */
import { LightningElement, wire } from 'lwc';

import { CurrentPageReference } from 'lightning/navigation';
import { getObjectInfo, getPicklistValues } from 'lightning/uiObjectInfoApi';

import getData from '@salesforce/apex/RecommendedBadgeMixController.getData';
import getSortOptions from '@salesforce/apex/SortCustomMetadataController.getSortOptions';

import { sortAlphabetic, sortCustom } from 'c/sortUtility';

import MIX_CATEGORY_ID_FIELD from '@salesforce/schema/Mix_Category__c.Id';
import MIX_CATEGORY_NAME_FIELD from '@salesforce/schema/Mix_Category__c.Name';
import MIX_CATEGORY_RECOMMENDED_BADGE_MIX_FIELD from '@salesforce/schema/Mix_Category__c.Recommended_Badge_Mix__c';

import RECOMMENDED_BADGE_OBJECT from '@salesforce/schema/Recommended_Badge__c';
import BADGE_ID_FIELD from '@salesforce/schema/Recommended_Badge__c.Id';
import BADGE_LEVEL_FIELD from '@salesforce/schema/Recommended_Badge__c.Level__c';
import BADGE_HYPERLINKEDNAME_FIELD from '@salesforce/schema/Recommended_Badge__c.HyperlinkedName__c';
import BADGE_NAME_FIELD from '@salesforce/schema/Recommended_Badge__c.BadgeName__c';
import RECOMMENDED_BADGE_NAME_FIELD from '@salesforce/schema/Recommended_Badge__c.Name';
import BADGE_TYPE_FIELD from '@salesforce/schema/Recommended_Badge__c.Type__c';
import BADGE_URL_FIELD from '@salesforce/schema/Recommended_Badge__c.URL__c';

import TRAIL_ID_FIELD from '@salesforce/schema/Recommended_Trail__c.Id';
import TRAIL_LEVEL_FIELD from '@salesforce/schema/Recommended_Trail__c.Level__c';
import TRAIL_HYPERLINKEDNAME_FIELD from '@salesforce/schema/Recommended_Trail__c.HyperlinkedName__c';
import TRAIL_NAME_FIELD from '@salesforce/schema/Recommended_Trail__c.TrailName__c';
import RECOMMENDED_TRAIL_NAME_FIELD from '@salesforce/schema/Recommended_Trail__c.Name';
import TRAIL_URL_FIELD from '@salesforce/schema/Recommended_Trail__c.URL__c';

import RECOMMENDED_BADGE_MIX_OBJECT from '@salesforce/schema/Recommended_Badge_Mix__c';
import RECOMMENDED_BADGE_MIX_NAME_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.Name';
import RECOMMENDED_BADGE_MIX_FREE_SF_BEN_PRACTICE_EXAM_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.FreeSFBenPracticeExam__c';
import RECOMMENDED_BADGE_MIX_LAST_UPDATED_DATE_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.Last_Updated_Date__c';
import RECOMMENDED_BADGE_MIX_OFFICIAL_EXAM_GUIDE_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.OfficialExamGuide__c';
import RECOMMENDED_BADGE_MIX_OFFICIAL_EXAM_TRAILMIX_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.OfficialExamTrailmix__c';
import RECOMMENDED_BADGE_MIX_OFFICIAL_PRACTICE_EXAM_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.OfficialPracticeExam__c';
import RECOMMENDED_BADGE_MIX_RECORD_TYPE_ID_FIELD from '@salesforce/schema/Recommended_Badge_Mix__c.RecordTypeId';
//import RECOMMENDED_BADGE_MIX_FIELD from '@salesforce/schema/Mix_Category__c.Recommended_Badge_Mix__r';

const MASTER_RECORD_TYPE_ID = '012000000000000AAA';
const EXPERIENCE_SITE_PAGE_TYPE = 'comm__namedPage';
const SPINNER_TEXT = 'Retrieving recommended badges';

/* eslint-disable sort-keys */
const TREEGRID_COLUMNS = [
    {
        type: 'url',
        fieldName: BADGE_URL_FIELD.fieldApiName.replace('__c', ''),
        label: 'Name',
        typeAttributes: {
            label: {
                fieldName: RECOMMENDED_BADGE_NAME_FIELD.fieldApiName
            }
        },
        initialWidth: 600
    },
    {
        fieldName: BADGE_TYPE_FIELD.fieldApiName.replace('__c', ''),
        label: 'Type'
    },
    {
        fieldName: BADGE_LEVEL_FIELD.fieldApiName.replace('__c', ''),
        label: 'Level'
    },
]

/*
 * {
 *   "type": "comm__namedPage",
 *   "attributes": {
 *       "name": "Home"
 *   },
 *   "state": {
 *       "app": "commeditor",
 *       "redirect": "false"
 *   }
 * }
 * {
 *   "type": "comm__namedPage",
 *   "attributes": {
 *       "name": "Home"
 *   },
 *   "state": {
 *       "app": "commeditor"
 *   }
 * }
 * 
 * {
 *   "type": "standard__namedPage",
 *   "attributes": {
 *       "pageName": "home"
 *   },
 *   "state": {}
 * }
 */

export default class RecommendedBadgeMixContainer extends LightningElement {
    badgeLevels;
    badgeMixesByName;
    badgeTypes;
    categoriesByBadgeMix;
    currentExpandedRows = [];
    defaultBadgeRecordTypeId;
    _displayExamResources = false;
    displayTable;
    filteredTreegridData;
    freeSFBenPracticeExam;
    _isExamMix = false;
    isLoading = true;
    currentLastUpdatedDate;
    keyField = BADGE_ID_FIELD.fieldApiName;
    mixLabel = 'Select Badge Mix';
    mixOptions;
    mixValue;
    officialExamGuide;
    officialExamTrailmix;
    officialPracticeExam;
    recordTypeNamesById;
    sortLabel = 'Sort By';
    sortOptions;
    sortValue;
    spinnerText = SPINNER_TEXT;
    treegridColumns = TREEGRID_COLUMNS;
    treegridData;
    treegridDataByMix;

    get displayExamResources() {
        if(this.isExamMix && this.pageRef?.type === EXPERIENCE_SITE_PAGE_TYPE) {
            this.displayExamResources = true;
        } else {
            this.displayExamResources = false;
        }
        return this._displayExamResources;
    }
    set displayExamResources(value) {
        this._displayExamResources = value;
    }

    get isExamMix() {
        return this._isExamMix;
    }
    set isExamMix(badgeMixName) {
        // eslint-disable-next-line no-magic-numbers
        const recordTypeName = this.recordTypeNamesById[this.badgeMixesByName[badgeMixName][RECOMMENDED_BADGE_MIX_RECORD_TYPE_ID_FIELD.fieldApiName]];
        this._isExamMix = recordTypeName === 'Exam';
    }

    @wire(CurrentPageReference)
    pageRef;

    @wire(getObjectInfo, { objectApiName : RECOMMENDED_BADGE_MIX_OBJECT })
    parseRecommendedBadgeMixObjectInfo({error, data}) {
        if(data) {
            this.recordTypeNamesById = {};
            for(const recordTypeInfo of Object.values(data.recordTypeInfos)) {
                this.recordTypeNamesById[recordTypeInfo.recordTypeId] = recordTypeInfo.name;
            }
        } else if(error) {
            this.template.querySelector('c-error').handleError(error);
        }
    }

    @wire(getObjectInfo, { objectApiName : RECOMMENDED_BADGE_OBJECT })
    parseRecommendedBadgeObjectInfo({error, data}) {
        if(data) {
            this.defaultBadgeRecordTypeId = data.defaultRecordTypeId;
        } else if(error) {
            this.template.querySelector('c-error').handleError(error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$defaultBadgeRecordTypeId', fieldApiName: BADGE_LEVEL_FIELD})
    parseBadgeLevels({error, data}) {
        if(data) {
            this.badgeLevels = [];
            data.values.forEach(value => (this.badgeLevels.push({label: value.label, value: value.value})));
        } else if(error) {
            this.template.querySelector('c-error').handleError(error);
        }
    }

    @wire(getPicklistValues, { recordTypeId: '$defaultBadgeRecordTypeId', fieldApiName: BADGE_TYPE_FIELD})
    parseBadgeTypes({error, data}) {
        if(data) {
            this.badgeTypes = [];
            data.values.forEach(value => (this.badgeTypes.push({label: value.label, value: value.value})));
        } else if(error) {
            this.template.querySelector('c-error').handleError(error);
        }
    }

    @wire(getData)
    parseData({error, data}) {
        if(data) {
            this.categoriesByBadgeMix = data.categoriesByBadgeMix;
            this.badgeMixesByName = data.badgeMixesByName;
            this.populateMixDropdown(data.defaultMix);
            this.parseTreegridData(data.defaultMix);
            this.currentLastUpdatedDate = this.badgeMixesByName[data.defaultMix][RECOMMENDED_BADGE_MIX_LAST_UPDATED_DATE_FIELD.fieldApiName];
            this.isExamMix = data.defaultMix;

            this.displayTable = true;
            this.isLoading = false;
        } else if(error) {
            this.template.querySelector('c-error').handleError(error);
        }
    }

    @wire(getSortOptions, {componentName: 'recommendedBadgeMixContainer'})
    parseSortOptions({error, data}) {
        if(data) {
            this.sortOptions = [];
            for(const option of data) {
                /* eslint-disable sort-keys */
                this.sortOptions.push({
                    label: option.MasterLabel,
                    value: option.MasterLabel,
                    sortableFieldValues: option.Sortable_Field_Values__r
                })   
            }
        } else if(error) {
            this.template.querySelector('c-error').handleError(error);
        }
    }

    renderedCallback() {
        if(this.treegridData && !this.displayTable) {
            this.displayTable = true;
        }

        if(this.isLoading && this.treegridData) {
            this.isLoading = false;
        }
    }

    populateMixDropdown(defaultMix) {
        const options = [];
        /* eslint-disable id-length */
        for(const a of Object.keys(this.categoriesByBadgeMix)) {
            options.push({label: a, value: a});
        }
        this.mixOptions = options;
        this.mixValue = defaultMix;
    }

    parseTreegridData(defaultMix) {
        this.treegridDataByMix = {};

        /* eslint-disable guard-for-in */
        for(const mix in this.categoriesByBadgeMix) {
            const extensibleMix = this.categoriesByBadgeMix[mix].map(item => {
                /* eslint-disable sort-keys, camelcase */                
                const newCategory = {
                    Id: item.mixCategory[MIX_CATEGORY_ID_FIELD.fieldApiName],
                    Name: item.mixCategory[MIX_CATEGORY_NAME_FIELD.fieldApiName],
                    URL: `/${item.mixCategory[MIX_CATEGORY_ID_FIELD.fieldApiName]}`, // this.pageRef.type === "comm__namedPage" ? undefined : '/' + item.Id,
                    _children: item.children,
                    Recommended_Badge_Mix__c: item.mixCategory[MIX_CATEGORY_RECOMMENDED_BADGE_MIX_FIELD.fieldApiName],
                };
                return newCategory;
            });

            this.treegridDataByMix[mix] = extensibleMix;
        }
        this.treegridData = this.treegridDataByMix[defaultMix];
        this.filteredTreegridData = this.treegridDataByMix[defaultMix];
        console.log(this.filteredTreegridData);
    }

    handleFilterChange(filterChange, filter) {
        const tempTreegridData = [...this.filteredTreegridData];
        console.log(JSON.parse(JSON.stringify(filterChange)));
        console.log(filter);
    }

    handleLevelFilterChange(event) {
        this.handleFilterChange(event.detail, 'level');
    }

    handleTypeFilterChange(event) {
        this.handleFilterChange(event.detail, 'type');
    }

    handleMixChange(event) {
        this.isExamMix = event.detail;
        if(this.isExamMix) {
            this.freeSFBenPracticeExam = this.badgeMixesByName[event.detail][RECOMMENDED_BADGE_MIX_FREE_SF_BEN_PRACTICE_EXAM_FIELD.fieldApiName];
            this.officialExamGuide = this.badgeMixesByName[event.detail][RECOMMENDED_BADGE_MIX_OFFICIAL_EXAM_GUIDE_FIELD.fieldApiName];
            this.officialExamTrailmix = this.badgeMixesByName[event.detail][RECOMMENDED_BADGE_MIX_OFFICIAL_EXAM_TRAILMIX_FIELD.fieldApiName];
            this.officialPracticeExam = this.badgeMixesByName[event.detail][RECOMMENDED_BADGE_MIX_OFFICIAL_PRACTICE_EXAM_FIELD.fieldApiName];
        }
        this.currentLastUpdatedDate = this.badgeMixesByName[event.detail][RECOMMENDED_BADGE_MIX_LAST_UPDATED_DATE_FIELD.fieldApiName];
        this.treegridData = this.treegridDataByMix[event.detail];
        this.filteredTreegridData = this.treegridDataByMix[event.detail];
    }

    handleSortChange(event) {
        this.currentExpandedRows = this.refs.treegrid.getCurrentExpandedRows();
        this.displayTable = false;
        const sortableFieldValues = this.sortOptions.find(option => (option.value === event.detail) && option.sortableFieldValues)?.sortableFieldValues.map(s => s.MasterLabel);
        const tempTreegridData = [...this.filteredTreegridData];

        for(const category of tempTreegridData) {
            /* eslint-disable no-magic-numbers */
            if(category._children.length > 1) {
                category._children = sortableFieldValues ? sortCustom(event.detail, category._children, sortableFieldValues) : sortAlphabetic(event.detail, category._children);
            }
        }
        this.filteredTreegridData = tempTreegridData;
    }

    handleExpandAll() {
        this.isLoading = true;
        this.refs.treegrid.expandAll();
    }

    handleCollapseAll() {
        this.isLoading = true;
        this.refs.treegrid.collapseAll();
    }
}