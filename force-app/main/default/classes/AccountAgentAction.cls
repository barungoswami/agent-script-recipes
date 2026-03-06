/**
 * Example Agent Action class that returns AccountList
 * This demonstrates how to use the Custom Lightning Type for Account Table
 */
global with sharing class AccountAgentAction {
    
    /**
     * Retrieves a list of accounts based on filters
     * This method can be used as an Agentforce action
     * 
     * @param accountType - Type of account (Customer, Prospect, etc.)
     * @param industry - Industry filter
     * @param minRevenue - Minimum annual revenue filter
     * @param maxRecords - Maximum number of records to return
     * @return AccountList wrapper with account data
     */
    @InvocableMethod(label='Get Accounts' description='Retrieves accounts based on specified criteria' category='Agent Actions')
    public static List<AccountResponse> getAccounts(List<AccountRequest> requests) {
        List<AccountResponse> results = new List<AccountResponse>();
        
        if (requests == null || requests.isEmpty()) {
            return results;
        }
        
        AccountRequest request = requests[0];
        
        // Build dynamic SOQL query
        String query = 'SELECT Id, Name, Type, Industry, Phone, Website, ' +
                       'AnnualRevenue, NumberOfEmployees, BillingCity, BillingState, ' +
                       'BillingCountry, Rating, CreatedDate ' +
                       'FROM Account WHERE Id != null';
        
        // Add filters
        if (String.isNotBlank(request.accountType)) {
            query += ' AND Type = :accountType';
        }
        
        if (String.isNotBlank(request.industry)) {
            query += ' AND Industry = :industry';
        }
        
        if (request.minRevenue != null && request.minRevenue > 0) {
            query += ' AND AnnualRevenue >= :minRevenue';
        }
        
        // Add ordering and limit
        query += ' ORDER BY CreatedDate DESC';
        
        Integer maxRecords = request.maxRecords != null && request.maxRecords > 0 
                             ? request.maxRecords 
                             : 50;
        query += ' LIMIT :maxRecords';
        
        try {
            // Execute query
            List<Account> accounts = Database.query(query);
            
            // Convert to AccountList wrapper
            AccountResponse accountResponse = new AccountResponse();
            AccountList accountList = accountResponse.result;
            accountList.accounts = new List<AccountData>();
            accountList.totalRecords = accounts.size();
            
            // Transform Account SObjects to AccountData
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
                    acc.CreatedDate != null ? Date.valueOf(acc.CreatedDate) : null
                );
                accountList.accounts.add(accData);
            }
            
            // Set message
            if (accountList.totalRecords == 0) {
                accountList.message = 'No accounts found matching the criteria.';
            } else if (accountList.totalRecords == 1) {
                accountList.message = 'Found 1 account.';
            } else {
                accountList.message = 'Found ' + accountList.totalRecords + ' accounts.';
            }
            
            results.add(accountResponse);
            
        } catch (Exception e) {
            // Handle errors gracefully
            AccountResponse errorResponse = new AccountResponse();
            AccountList errorList = errorResponse.result;
            errorList.accounts = new List<AccountData>();
            errorList.totalRecords = 0;
            errorList.message = 'Error retrieving accounts: ' + e.getMessage();
            results.add(errorResponse);
        }
        
        return results;
    }
    
    /**
     * Output wrapper class for the invocable method
     */
    global class AccountResponse {
        @InvocableVariable(label='Account List Result' description='List of accounts matching criteria')
        global AccountList result;
        
        global AccountResponse() {
            this.result = new AccountList();
        }
    }
    
    /**
     * Input wrapper class for the invocable method
     */
    global class AccountRequest {
        @InvocableVariable(label='Account Type' description='Filter by account type (e.g., Customer, Prospect)')
        global String accountType;
        
        @InvocableVariable(label='Industry' description='Filter by industry')
        global String industry;
        
        @InvocableVariable(label='Minimum Revenue' description='Minimum annual revenue')
        global Decimal minRevenue;
        
        @InvocableVariable(label='Max Records' description='Maximum number of records to return (default: 50)')
        global Integer maxRecords;
    }
}