import { LightningElement, api } from 'lwc';

/**
 * Lightning Web Component to display accounts with related contacts in an accordion
 * Used with Custom Lightning Type: accountContactAccordion
 */
export default class AccountContactAccordion extends LightningElement {
    @api value;
    
    accountsData = [];
    totalAccounts = 0;
    totalContacts = 0;
    message = '';
    activeSections = [];

    connectedCallback() {
        if (this.value) {
            const accounts = this.value.accounts || [];
            this.totalAccounts = this.value.totalAccounts || 0;
            this.totalContacts = this.value.totalContacts || 0;
            this.message = this.value.message || '';
            
            // Transform account data for the accordion
            this.accountsData = accounts.map((account, index) => {
                // Build location string
                const locationParts = [
                    account.billingCity,
                    account.billingState,
                    account.billingCountry
                ].filter(Boolean);
                
                // Build Account URL
                const accountUrl = account.accountId 
                    ? `/${account.accountId}` 
                    : null;
                
                // Determine rating class for styling
                let ratingClass = 'slds-badge';
                let ratingVariant = '';
                if (account.rating === 'Hot') {
                    ratingClass = 'slds-badge slds-theme_error';
                    ratingVariant = 'error';
                } else if (account.rating === 'Warm') {
                    ratingClass = 'slds-badge slds-theme_warning';
                    ratingVariant = 'warning';
                } else if (account.rating === 'Cold') {
                    ratingClass = 'slds-badge';
                    ratingVariant = 'light';
                }
                
                // Transform contacts
                const transformedContacts = (account.contacts || []).map(contact => {
                    const contactUrl = contact.contactId 
                        ? `/${contact.contactId}` 
                        : null;
                    
                    const contactLocation = [
                        contact.mailingCity,
                        contact.mailingState,
                        contact.mailingCountry
                    ].filter(Boolean).join(', ');
                    
                    return {
                        ...contact,
                        contactUrl: contactUrl,
                        displayName: contact.fullName || 'N/A',
                        displayEmail: contact.email || '-',
                        displayPhone: contact.phone || '-',
                        displayMobile: contact.mobilePhone || '-',
                        displayTitle: contact.title || '-',
                        displayDepartment: contact.department || '-',
                        displayLocation: contactLocation || '-',
                        displayBirthdate: contact.birthdate ? this.formatDate(contact.birthdate) : '-'
                    };
                });
                
                return {
                    id: `account-${index}`,
                    accountId: account.accountId,
                    accountUrl: accountUrl,
                    accountName: account.accountName || 'N/A',
                    accountType: account.accountType || '-',
                    industry: account.industry || '-',
                    phone: account.phone || '-',
                    website: account.website || null,
                    annualRevenue: account.annualRevenue || 0,
                    numberOfEmployees: account.numberOfEmployees || 0,
                    rating: account.rating || '-',
                    ratingClass: ratingClass,
                    ratingVariant: ratingVariant,
                    location: locationParts.length > 0 ? locationParts.join(', ') : '-',
                    contactCount: account.contactCount || 0,
                    contacts: transformedContacts,
                    hasContacts: transformedContacts.length > 0,
                    contactsLabel: `${transformedContacts.length} Contact${transformedContacts.length !== 1 ? 's' : ''}`
                };
            });
            
            // Auto-expand first section if there's data
            if (this.accountsData.length > 0) {
                this.activeSections = [this.accountsData[0].id];
            }
        }
    }
    
    formatDate(dateValue) {
        if (!dateValue) return '-';
        try {
            const date = new Date(dateValue);
            return date.toLocaleDateString('en-US', { 
                year: 'numeric', 
                month: 'short', 
                day: '2-digit' 
            });
        } catch (e) {
            return dateValue;
        }
    }
    
    formatCurrency(amount) {
        if (!amount) return '$0';
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD',
            minimumFractionDigits: 0
        }).format(amount);
    }
    
    get hasAccounts() {
        return this.accountsData && this.accountsData.length > 0;
    }
    
    get displayMessage() {
        if (this.message) return this.message;
        return `${this.totalAccounts} Account${this.totalAccounts !== 1 ? 's' : ''} with ${this.totalContacts} Contact${this.totalContacts !== 1 ? 's' : ''}`;
    }
    
    get formattedAccountsData() {
        return this.accountsData.map(account => ({
            ...account,
            formattedRevenue: this.formatCurrency(account.annualRevenue)
        }));
    }
    
    handleSectionToggle(event) {
        this.activeSections = event.detail.openSections;
    }
}