/**
 * Agent Action to filter accounts by industry
 * Uses dual-listbox for INPUT and data table for OUTPUT
 */
global with sharing class AccountIndustryFilterAction {
    
    /**
     * Filters accounts based on selected industries
     * 
     * @param filterRequest - Contains selected industries and additional filters
     * @return AccountFilterResponse with filtered accounts
     */
    @InvocableMethod(label='Filter Accounts by Industry' description='Filter accounts using industry dual-listbox' category='Agent Actions')
    global static List<AccountFilterOutputResponse> filterAccountsByIndustry(List<AccountFilterInputRequest> requests) {
        List<AccountFilterOutputResponse> results = new List<AccountFilterOutputResponse>();
        
        if (requests == null || requests.isEmpty()) {
            return results;
        }
        
        AccountFilterInputRequest request = requests[0];
        AccountFilterRequest filterReq = request.filterRequest;
        
        if (filterReq == null) {
            filterReq = new AccountFilterRequest();
        }
        
        try {
            // Build dynamic SOQL query
            String query = 'SELECT Id, Name, Type, Industry, Phone, Website, ' +
                          'AnnualRevenue, NumberOfEmployees, BillingCity, BillingState, ' +
                          'BillingCountry, Rating ' +
                          'FROM Account WHERE Id != null';
            
            // Add industry filter
            List<String> selectedIndustries = filterReq.selectedIndustries;
            String accountType = filterReq.accountType;
            
            if (selectedIndustries != null && !selectedIndustries.isEmpty()) {
                query += ' AND Industry IN :selectedIndustries';
            }
            
            // Add account type filter
            if (String.isNotBlank(accountType)) {
                query += ' AND Type = :accountType';
            }
            
            // Add ordering and limit
            query += ' ORDER BY Industry, Name ASC';
            
            Integer maxRecords = filterReq.maxRecords != null && filterReq.maxRecords > 0 
                                 ? filterReq.maxRecords 
                                 : 50;
            query += ' LIMIT :maxRecords';
            
            // Execute query
            List<Account> accounts = Database.query(query);
            
            // Convert to response
            AccountFilterOutputResponse response = new AccountFilterOutputResponse();
            AccountFilterResponse filterResponse = response.filterResponse;
            
            // Transform accounts
            for (Account acc : accounts) {
                AccountData accData = new AccountData(
                    acc.Id,
                    acc.Name,
                    acc.Type,
                    acc.Industry,
                    acc.Phone,
                    acc.Website,
                    acc.AnnualRevenue,
                    acc.NumberOfEmployees,
                    acc.BillingCity,
                    acc.BillingState,
                    acc.BillingCountry,
                    acc.Rating,
                    null // createdDate not needed for this view
                );
                filterResponse.accounts.add(accData);
            }
            
            filterResponse.totalRecords = filterResponse.accounts.size();
            filterResponse.appliedFilters = selectedIndustries != null ? selectedIndustries : new List<String>();
            
            // Set message
            if (filterResponse.totalRecords == 0) {
                if (selectedIndustries != null && !selectedIndustries.isEmpty()) {
                    filterResponse.message = 'No accounts found for selected industries.';
                } else {
                    filterResponse.message = 'Please select at least one industry to filter accounts.';
                }
            } else {
                String filterText = selectedIndustries != null && !selectedIndustries.isEmpty() 
                                    ? String.join(selectedIndustries, ', ') 
                                    : 'all industries';
                filterResponse.message = 'Found ' + filterResponse.totalRecords + 
                                        ' account' + (filterResponse.totalRecords != 1 ? 's' : '') +
                                        ' in: ' + filterText;
            }
            
            results.add(response);
            
        } catch (Exception e) {
            // Handle errors gracefully
            AccountFilterOutputResponse errorResponse = new AccountFilterOutputResponse();
            AccountFilterResponse errorFilter = errorResponse.filterResponse;
            errorFilter.accounts = new List<AccountData>();
            errorFilter.totalRecords = 0;
            errorFilter.appliedFilters = new List<String>();
            errorFilter.message = 'Error filtering accounts: ' + e.getMessage();
            results.add(errorResponse);
        }
        
        return results;
    }
    
    /**
     * Input wrapper class for the invocable method
     */
    global class AccountFilterInputRequest {
        @InvocableVariable(label='Filter Request' description='Industry filter criteria from dual-listbox')
        global AccountFilterRequest filterRequest;
    }
    
    /**
     * Output wrapper class for the invocable method
     */
    global class AccountFilterOutputResponse {
        @InvocableVariable(label='Filter Response' description='Filtered accounts result')
        global AccountFilterResponse filterResponse;
        
        global AccountFilterOutputResponse() {
            this.filterResponse = new AccountFilterResponse();
        }
    }
}