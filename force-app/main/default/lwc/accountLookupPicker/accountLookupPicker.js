import { api, LightningElement } from 'lwc';

/**
 * Account lookup picker using lightning-record-picker
 * Allows searching and selecting an Account record
 */
export default class AccountLookupPicker extends LightningElement {
    @api
    get readOnly() {
        return this._readOnly;
    }
    set readOnly(value) {
        this._readOnly = value;
    }
    _readOnly = false;

    @api
    get value() {
        return this._value;
    }
    set value(value) {
        this._value = value;
        if (value && value.accountId) {
            this.selectedRecordId = value.accountId;
        }
    }
    _value;

    selectedRecordId = null;

    handleChange(event) {
        const recordId = event.detail.recordId;
        this.selectedRecordId = recordId;
        
        // Dispatch value change event with selected account ID
        const accountData = {
            accountId: recordId || '',
            accountName: ''
        };

        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: {
                value: accountData
            }
        }));
    }

    get placeholder() {
        return this.readOnly ? 'Account lookup is read-only' : 'Search Accounts...';
    }
}