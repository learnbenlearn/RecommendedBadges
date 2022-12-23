import { LightningElement, api, track } from 'lwc';

export default class Lookup extends LightningElement {
  allowBlur = true;
  _lookupItems;
  @api objectName;
  @api resultIconName;
  @track searchResults;
  _selectedItem

  @api
  get selectedItem() {
    return this._selectedItem;
  }
  set selectedItem(value) {
    this._selectedItem = value;
  }

  get lookupItems() {
    return this._lookupItems;
  };
  @api
  set lookupItems(value) {
    this._lookupItems = value;
    this.searchResults = value;
  }

  handleInputChange(event) {
    if(event.target.value.length === 0) {
      this.searchResults = this._lookupItems;
    } else {
      this.searchResults = this.searchResults.filter(searchResult => searchResult.Name.toLowerCase().includes(event.target.value));
    }
  }

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
    this.searchResults = this._lookupItems;
    this.selectedItem = null;
  }

  closeDropdown() {
    let div = this.template.querySelector('div.slds-combobox.slds-dropdown-trigger.slds-dropdown-trigger_click');
    if(div.classList.contains('slds-is-open')) {
        div.classList.remove('slds-is-open');
    }
  }

  testHandler(event) {
    console.log(event);
  }
}