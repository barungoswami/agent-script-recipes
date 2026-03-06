import { LightningElement, api } from 'lwc';

/**
 * Lightning Web Component to display accounts in a data table
 * Used with Custom Lightning Type: accountTable
 */
export default class AccountDataTable extends LightningElement {
    @api value;
    
    accounts = [];
    totalRecords = 0;
    message = '';
    
    // Define columns for the data table
    columns = [
        { 
            label: 'Account Name', 
            fieldName: 'accountId', 
            type: 'url',
            typeAttributes: {
                label: { fieldName: 'accountName' },
                target: '_blank'
            },
            sortable: true
        },
        { 
            label: 'Type', 
            fieldName: 'accountType', 
            type: 'text',
            sortable: true
        },
        { 
            label: 'Industry', 
            fieldName: 'industry', 
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
            sortable: true,
            cellAttributes: { alignment: 'left' }
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
        },
        { 
            label: 'Created Date', 
            fieldName: 'createdDate', 
            type: 'date',
            typeAttributes: {
                year: 'numeric',
                month: 'short',
                day: '2-digit'
            },
            sortable: true
        }
    ];

    connectedCallback() {
        if (this.value) {
            // Extract data from the Apex response
            const accountsData = this.value.accounts || [];
            this.totalRecords = this.value.totalRecords || 0;
            this.message = this.value.message || '';
            
            // Transform account data for the data table
            this.accounts = accountsData.map(account => {
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
                let ratingClass = '';
                if (account.rating === 'Hot') {
                    ratingClass = 'slds-text-color_error slds-text-title_bold';
                } else if (account.rating === 'Warm') {
                    ratingClass = 'slds-text-color_warning slds-text-title_bold';
                } else if (account.rating === 'Cold') {
                    ratingClass = 'slds-text-color_weak';
                }
                
                return {
                    accountId: accountUrl,
                    accountName: account.accountName || 'N/A',
                    accountType: account.accountType || '-',
                    industry: account.industry || '-',
                    phone: account.phone || '-',
                    website: account.website || null,
                    annualRevenue: account.annualRevenue || 0,
                    numberOfEmployees: account.numberOfEmployees || 0,
                    rating: account.rating || '-',
                    ratingClass: ratingClass,
                    location: locationParts.length > 0 ? locationParts.join(', ') : '-',
                    createdDate: account.createdDate || null
                };
            });
        }
    }
    
    get hasAccounts() {
        return this.accounts && this.accounts.length > 0;
    }
    
    get displayMessage() {
        return this.message || `Showing ${this.accounts.length} of ${this.totalRecords} accounts`;
    }
}