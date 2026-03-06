import { api, LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

/**
 * Display selected Account details in a lightning-card
 * Shows comprehensive account information with formatted fields
 */
export default class AccountLookupCard extends NavigationMixin(LightningElement) {
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
    }
    _value;

    get hasData() {
        return this._value && this._value.accountId;
    }

    get accountName() {
        return this._value?.accountName || 'N/A';
    }

    get accountId() {
        return this._value?.accountId;
    }

    get accountType() {
        return this._value?.accountType || 'N/A';
    }

    get industry() {
        return this._value?.industry || 'N/A';
    }

    get phone() {
        return this._value?.phone || 'N/A';
    }

    get website() {
        return this._value?.website || 'N/A';
    }

    get formattedRevenue() {
        if (this._value?.annualRevenue) {
            return new Intl.NumberFormat('en-US', {
                style: 'currency',
                currency: 'USD',
                minimumFractionDigits: 0
            }).format(this._value.annualRevenue);
        }
        return 'N/A';
    }

    get numberOfEmployees() {
        if (this._value?.numberOfEmployees) {
            return new Intl.NumberFormat('en-US').format(this._value.numberOfEmployees);
        }
        return 'N/A';
    }

    get rating() {
        return this._value?.rating || 'N/A';
    }

    get accountSource() {
        return this._value?.accountSource || 'N/A';
    }

    get ownerName() {
        return this._value?.ownerName || 'N/A';
    }

    get billingAddress() {
        const street = this._value?.billingStreet || '';
        const city = this._value?.billingCity || '';
        const state = this._value?.billingState || '';
        const postalCode = this._value?.billingPostalCode || '';
        const country = this._value?.billingCountry || '';

        const parts = [street, city, state, postalCode, country].filter(Boolean);
        return parts.length > 0 ? parts.join(', ') : 'N/A';
    }

    get description() {
        return this._value?.description || 'No description available';
    }

    get createdDate() {
        return this._value?.createdDate || 'N/A';
    }

    get lastModifiedDate() {
        return this._value?.lastModifiedDate || 'N/A';
    }

    get ratingVariant() {
        const rating = this._value?.rating;
        if (rating === 'Hot') return 'error';
        if (rating === 'Warm') return 'warning';
        if (rating === 'Cold') return 'inverse';
        return 'neutral';
    }

    handleNavigateToAccount() {
        if (this.accountId) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.accountId,
                    objectApiName: 'Account',
                    actionName: 'view'
                }
            });
        }
    }
}