import { api, LightningElement } from 'lwc';

/**
 * Editor component for filtering accounts by industry
 * Uses dual-listbox for multi-select industry filtering
 */
export default class AccountIndustryEditor extends LightningElement {
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
        if (value) {
            this.selectedIndustries = value.selectedIndustries || [];
            this.maxRecords = value.maxRecords || 50;
            this.accountType = value.accountType || '';
        }
    }
    _value;

    // Available industry options
    industryOptions = [
        { label: 'Agriculture', value: 'Agriculture' },
        { label: 'Apparel', value: 'Apparel' },
        { label: 'Banking', value: 'Banking' },
        { label: 'Biotechnology', value: 'Biotechnology' },
        { label: 'Chemicals', value: 'Chemicals' },
        { label: 'Communications', value: 'Communications' },
        { label: 'Construction', value: 'Construction' },
        { label: 'Consulting', value: 'Consulting' },
        { label: 'Education', value: 'Education' },
        { label: 'Electronics', value: 'Electronics' },
        { label: 'Energy', value: 'Energy' },
        { label: 'Engineering', value: 'Engineering' },
        { label: 'Entertainment', value: 'Entertainment' },
        { label: 'Environmental', value: 'Environmental' },
        { label: 'Finance', value: 'Finance' },
        { label: 'Food & Beverage', value: 'Food & Beverage' },
        { label: 'Government', value: 'Government' },
        { label: 'Healthcare', value: 'Healthcare' },
        { label: 'Hospitality', value: 'Hospitality' },
        { label: 'Insurance', value: 'Insurance' },
        { label: 'Machinery', value: 'Machinery' },
        { label: 'Manufacturing', value: 'Manufacturing' },
        { label: 'Media', value: 'Media' },
        { label: 'Not For Profit', value: 'Not For Profit' },
        { label: 'Other', value: 'Other' },
        { label: 'Recreation', value: 'Recreation' },
        { label: 'Retail', value: 'Retail' },
        { label: 'Shipping', value: 'Shipping' },
        { label: 'Technology', value: 'Technology' },
        { label: 'Telecommunications', value: 'Telecommunications' },
        { label: 'Transportation', value: 'Transportation' },
        { label: 'Utilities', value: 'Utilities' }
    ];

    // Account type options
    accountTypeOptions = [
        { label: 'Any Type', value: '' },
        { label: 'Customer - Direct', value: 'Customer - Direct' },
        { label: 'Customer - Channel', value: 'Customer - Channel' },
        { label: 'Prospect', value: 'Prospect' },
        { label: 'Partner', value: 'Partner' },
        { label: 'Other', value: 'Other' }
    ];

    selectedIndustries = [];
    maxRecords = 50;
    accountType = '';

    handleIndustryChange(event) {
        this.selectedIndustries = event.detail.value;
        this.dispatchValueChange();
    }

    handleMaxRecordsChange(event) {
        this.maxRecords = parseInt(event.target.value, 10) || 50;
        this.dispatchValueChange();
    }

    handleAccountTypeChange(event) {
        this.accountType = event.detail.value;
        this.dispatchValueChange();
    }

    dispatchValueChange() {
        const filterValue = {
            selectedIndustries: this.selectedIndustries,
            maxRecords: this.maxRecords,
            accountType: this.accountType
        };

        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: {
                value: filterValue
            }
        }));
    }

    get isIndustrySelected() {
        return this.selectedIndustries && this.selectedIndustries.length > 0;
    }

    get selectedIndustryCount() {
        return this.selectedIndustries ? this.selectedIndustries.length : 0;
    }
}