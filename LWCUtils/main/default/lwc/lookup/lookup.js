import { LightningElement, api } from 'lwc';

const LOOKUP_LABEL = 'Mix Category';
const SEARCH_RESULTS = [
    {
      "Name": "Leadership",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "OmniStudio",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Tableau",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Tableau Projects",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Industries",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Other",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Potential Recommended Projects",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Quick Looks",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Marketing Cloud",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Just for Ben",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Mobile Development",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Potential Recommended Badges",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "AWS",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Marketing Cloud Developer",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "AppExchange",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "General Cybersecurity",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "Einstein Next Best Action",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Platform Developer I Certification Prep",
      "secondaryFieldValue": "Recommended PDI Badges"
    },
    {
      "Name": "Administrator Certification Prep",
      "secondaryFieldValue": "Recommended ADM Badges"
    },
    {
      "Name": "Declarative User Interface",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Salesforce Fundamentals",
      "secondaryFieldValue": "Recommended PDI Badges"
    },
    {
      "Name": "Data Modeling & Management",
      "secondaryFieldValue": "Recommended PDI Badges"
    },
    {
      "Name": "Process Automation & Logic",
      "secondaryFieldValue": "Recommended PDI Badges"
    },
    {
      "Name": "User Interface",
      "secondaryFieldValue": "Recommended PDI Badges"
    },
    {
      "Name": "Testing, Debugging, & Deployment",
      "secondaryFieldValue": "Recommended PDI Badges"
    },
    {
      "Name": "Configuration & Setup",
      "secondaryFieldValue": "Recommended ADM Badges"
    },
    {
      "Name": "Object Manager & Lightning App Builder",
      "secondaryFieldValue": "Recommended ADM Badges"
    },
    {
      "Name": "Sales & Marketing Applications",
      "secondaryFieldValue": "Recommended ADM Badges"
    },
    {
      "Name": "Service & Support Applications",
      "secondaryFieldValue": "Recommended ADM Badges"
    },
    {
      "Name": "Productivity & Collaboration",
      "secondaryFieldValue": "Recommended ADM Badges"
    },
    {
      "Name": "Data & Analytics Management",
      "secondaryFieldValue": "Recommended ADM Badges"
    },
    {
      "Name": "Workflow/Process Automation",
      "secondaryFieldValue": "Recommended ADM Badges"
    },
    {
      "Name": "AMPscript",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Marketing Basics",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Email Marketing",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Administration",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Administration Projects",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Administrator Certification",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Advanced Administration",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Advanced Apex",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Agile Frameworks",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Apex",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Apex & CRUD",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Apex Security",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "AppExchange",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Application Lifecycle & Development Models",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Chatter",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Custom Metadata Types & Custom Settings",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Data Quality & Management",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Data Model",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Data Visualization",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Deployment",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Auditing",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Email Integration",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Experience Cloud",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Flows",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Github",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Governor Limits & Performance",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Heroku & Salesforce Connect",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Integration",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "JavaScript",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Lightning Aura Components",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Lightning Design System",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Lightning Web Components",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Package Based Development & SFDX",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Platform Developer I Certification",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Platform Events",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Presentation Fundamentals",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Process Automation",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Salesforce Introduction",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Salesforce Mobile App",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Sales Cloud",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Sandboxes",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Security",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Service Cloud",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Testing",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Trailhead",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Triggers",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Visual Studio Code",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Visualforce",
      "secondaryFieldValue": "Recommended Trailhead Badges"
    },
    {
      "Name": "Data Management",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Journey Builder & Automation Studio",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Content Builder & Email Studio",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "SQL",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Marketing Cloud Connect",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Administration",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Data Analysis",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Marketing Cloud Basics",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Development",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Marketing Cloud Apps",
      "secondaryFieldValue": "Marketing Cloud"
    },
    {
      "Name": "Development Lifecycle and Deployment Designer",
      "secondaryFieldValue": "Ben's Mix"
    },
    {
      "Name": "User Experience Designer Certification",
      "secondaryFieldValue": "Ben's Mix"
    }
];
// 92, stop at what number?
const RESULT_ICON_NAME = 'custom:custom46';
const OBJECT_NAME = 'Mix Category';
  

export default class Lookup extends LightningElement {
    allowBlur = true;
    @api lookupLabel = LOOKUP_LABEL;
    @api searchResults = SEARCH_RESULTS;
    @api resultIconName = RESULT_ICON_NAME;
    @api objectName = OBJECT_NAME;
    selectedItem;


    handleInputFocus() {
        let div = this.template.querySelector('div.slds-combobox.slds-dropdown-trigger.slds-dropdown-trigger_click');
        if(!div.classList.contains('slds-is-open')) {
            div.classList.add('slds-is-open');
        }
    }

    handleInputBlur() {
        if(this.allowBlur) {
            this.closeDropdown();
        }
    }

    handleItemClick(event) {
        this.selectedItem = event.detail;
        this.closeDropdown();
    }

    handleItemMouseDown() {
        this.allowBlur = false;
    }

    handleItemMouseUp() {
        this.allowBlur = true;
    }

    handleRemoveSelectedItem() {
        this.selectedItem = null;
    }

    closeDropdown() {
        let div = this.template.querySelector('div.slds-combobox.slds-dropdown-trigger.slds-dropdown-trigger_click');
        if(div.classList.contains('slds-is-open')) {
            div.classList.remove('slds-is-open');
        }
    }
}