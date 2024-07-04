import { LightningElement, api, track } from 'lwc';

import FORM_FACTOR from "@salesforce/client/formFactor";

// temp
const LOGGER_NAME = 'c-logger';
const SAVE_METHOD = 'SYNCHRONOUS_DML';

export default class Lookup extends LightningElement {
	allowBlur = true;
	firstRender = true;
	isSearchLoading = false;
	_lookupItems;
	@api objectName;
	@api placeholder;
	@api resultIconName;
	@api required = false;
	@track searchResults;
	_selectedId;
	_selectedItem;
	timeoutId;
	_twoColumnLayout = false;
	infoLogging = false; // temp

	get twoColumnLayout() {
		return this._twoColumnLayout;
	}
	@api
	set twoColumnLayout(value) {
		if(value === true) {
			this._twoColumnLayout = true;
		}
	}

	@api
	get selectedItem() {
		return this._selectedItem;
	}
	set selectedItem(value) {
		this._selectedItem = value;
	}

	get selectedId() {
		return this._selectedId;
	}
	@api
	set selectedId(value) {
		if(value) {
			this._selectedId = value;
			if(this.lookupItems.length > 0) {
				this.selectedItem = this.lookupItems.find(lookupItem => lookupItem.Id === value);
			}
		}
	}

	get lookupItems() {
		return this._lookupItems;
	};
	@api
	set lookupItems(value) {
		this._lookupItems = JSON.parse(JSON.stringify([...value]));
		this.searchResults = JSON.parse(JSON.stringify([...value]));
	}

	renderedCallback() {
		if(this.lookupItems.length > 0 && this.selectedId && this.firstRender) {
			this.selectedItem = this.lookupItems.find(lookupItem => lookupItem.Id === this.selectedId);
			this.firstRender = false;
		}

		if(FORM_FACTOR === 'Medium' && this.twoColumnLayout) {
			this.refs.lookupLabel.classList.replace('slds-medium-size_1-of-1', 'slds-medium-size_1-of-3');
			this.refs.lookupSearch?.classList.replace('slds-medium-size_1-of-1', 'slds-medium-size_2-of-3');
			this.refs.lookupSelect?.classList.replace('slds-medium-size_1-of-1', 'slds-medium-size_2-of-3');
		}
	}

	@api reset() {
		if(this.selectedId) {
			this.selectedItem = this.lookupItems.find(lookupItem => lookupItem.Id === this.selectedId);
		} else {
			this.selectedItem = null;
		}
	}

	handleInputChange(event) {
		this.isSearchLoading = true;
		clearTimeout(this.timeoutId);
		this.timeoutId = setTimeout(this.filterSearchResults.bind(this), 500, event.target.value);
	}

	filterSearchResults(searchTerm) {
		if(searchTerm.length === 0) {
			this.searchResults = this.lookupItems.slice(0, 200);
		} else {
			this.searchResults = this.lookupItems.filter(searchResult => searchResult.Name.toLowerCase().includes(searchTerm));
			this.searchResults = this.searchResults.slice(0, 200);
		}
		this.isSearchLoading = false;

		// temp
		if(this.infoLogging) {		
			this.log(`searchTerm: ${searchTerm}\n searchResults: ${this.searchResults}\n lookupItems first 5: ${this.lookupItems.slice(0, 5)}`);
		}
	}

	handleInputFocus() {
		let div = this.refs.dropdownDiv;
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
		this.dispatchEvent(new CustomEvent('itemselect', {detail: this.selectedItem}));
	}

	handleItemMouseDown() {
		this.allowBlur = false;
	}

	handleItemMouseUp() {
		this.allowBlur = true;
	}

	handleRemoveSelectedItem() {
		this.searchResults = this.lookupItems;
		this.selectedItem = null;
	}

	closeDropdown() {
		let div = this.refs.dropdownDiv;
		if(div.classList.contains('slds-is-open')) {
				div.classList.remove('slds-is-open');
		}
	}

	// temp
    log(message) {
        const logger = this.template.querySelector(LOGGER_NAME);
		console.log(message);
        logger.info(message);
        logger.saveLog(SAVE_METHOD);
    }

	handleSearchInfoLogging() {
		this.infoLogging = true;
	}
}