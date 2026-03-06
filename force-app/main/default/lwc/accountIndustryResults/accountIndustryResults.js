import { LightningElement, api } from 'lwc';

/**
 * Renderer component to display filtered account results
 * Shows accounts based on industry filter selection
 */
export default class AccountIndustryResults extends LightningElement {
    @api value;
    
    accounts = [];
    totalRecords = 0;
    appliedFilters = [];
    message = '';

    // Define columns for the data table
    columns = [
        { 
            label: 'Account Name', 
            fieldName: 'accountUrl', 
            type: 'url',
            typeAttributes: {
                label: { fieldName: 'accountName' },
                target: '_blank'
            },
            sortable: true
        },
        { 
            label: 'Industry', 
            fieldName: 'industry', 
            type: 'text',
            sortable: true,
            cellAttributes: { 
                class: { fieldName: 'industryClass' }
            }
        },
        { 
            label: 'Type', 
            fieldName: 'accountType', 
            type: 'text',
            sortable: true
        },
        { 
            label: 'Phone', 
            fieldName: 'phone', 
            type: 'phone'
        },
        { 
            label: 'Website', 
            fieldName: 'website', 
            type: 'url',
            typeAttributes: {
                target: '_blank'
            }
        },
        { 
            label: 'Annual Revenue', 
            fieldName: 'annualRevenue', 
            type: 'currency',
            sortable: true
        },
        { 
            label: 'Employees', 
            fieldName: 'numberOfEmployees', 
            type: 'number',
            sortable: true
        },
        { 
            label: 'Rating', 
            fieldName: 'rating', 
            type: 'text',
            cellAttributes: { 
                class: { fieldName: 'ratingClass' }
            }
        },
        { 
            label: 'Location', 
            fieldName: 'location', 
            type: 'text'
        }
    ];

    connectedCallback() {
        if (this.value) {
            const accountsData = this.value.accounts || [];
            this.totalRecords = this.value.totalRecords || 0;
            this.appliedFilters = this.value.appliedFilters || [];
            this.message = this.value.message || '';
            
            // Transform account data
            this.accounts = accountsData.map(account => {
                const locationParts = [
                    account.billingCity,
                    account.billingState,
                    account.billingCountry
                ].filter(Boolean);
                
                const accountUrl = account.accountId 
                    ? `/${account.accountId}` 
                    : null;
                
                // Industry highlighting class
                let industryClass = 'industry-badge';
                if (this.appliedFilters.includes(account.industry)) {
                    industryClass = 'industry-badge industry-selected';
                }
                
                // Rating class
                let ratingClass = 'slds-badge';
                if (account.rating === 'Hot') {
                    ratingClass = 'slds-badge slds-theme_error';
                } else if (account.rating === 'Warm') {
                    ratingClass = 'slds-badge slds-theme_warning';
                }
                
                return {
                    accountId: account.accountId,
                    accountUrl: accountUrl,
                    accountName: account.accountName || 'N/A',
                    accountType: account.accountType || '-',
                    industry: account.industry || '-',
                    industryClass: industryClass,
                    phone: account.phone || '-',
                    website: account.website || null,
                    annualRevenue: account.annualRevenue || 0,
                    numberOfEmployees: account.numberOfEmployees || 0,
                    rating: account.rating || '-',
                    ratingClass: ratingClass,
                    location: locationParts.length > 0 ? locationParts.join(', ') : '-'
                };
            });
        }
    }
    
    get hasAccounts() {
        return this.accounts && this.accounts.length > 0;
    }
    
    get displayMessage() {
        return this.message || `Found ${this.totalRecords} account${this.totalRecords !== 1 ? 's' : ''}`;
    }
    
    get hasFilters() {
        return this.appliedFilters && this.appliedFilters.length > 0;
    }
    
    get filterChips() {
        return this.appliedFilters.map((filter, index) => ({
            label: filter,
            name: `filter-${index}`
        }));
    }
}