import { LightningElement, api, track } from 'lwc';

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
    this._lookupItems = value;
    this.searchResults = value;
  }

  renderedCallback() {
    if(this.lookupItems.length > 0 && this.selectedId && this.firstRender) {
      this.selectedItem = this.lookupItems.find(lookupItem => lookupItem.Id === this.selectedId);
      this.firstRender = false;
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
}