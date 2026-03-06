/**
 * Agent action for Account Lookup Custom Lightning Type
 * Queries and returns detailed account information
 */
global with sharing class AccountLookupAction {
    
    /**
     * Get detailed Account information by ID
     * @param requests List of AccountLookupWrapper containing account IDs
     * @return List of AccountLookupResult with account details
     */
    @InvocableMethod(
        label='Account Lookup Action'
        description='Retrieves detailed information for a selected Account record'
        category='Account'
    )
    global static List<AccountLookupResult> getAccountDetails(List<AccountLookupWrapper> requests) {
        List<AccountLookupResult> results = new List<AccountLookupResult>();
        
        if (requests == null || requests.isEmpty()) {
            AccountLookupResult errorResult = new AccountLookupResult();
            errorResult.success = false;
            errorResult.message = 'No account ID provided';
            results.add(errorResult);
            return results;
        }
        
        AccountLookupRequest request = requests[0].request;
        
        if (String.isBlank(request.accountId)) {
            AccountLookupResult errorResult = new AccountLookupResult();
            errorResult.success = false;
            errorResult.message = 'Account ID is required';
            results.add(errorResult);
            return results;
        }
        
        try {
            // Query account with all relevant fields
            List<Account> accounts = [
                SELECT 
                    Id,
                    Name,
                    Type,
                    Industry,
                    Phone,
                    Website,
                    AnnualRevenue,
                    NumberOfEmployees,
                    Rating,
                    AccountSource,
                    Owner.Name,
                    OwnerId,
                    BillingStreet,
                    BillingCity,
                    BillingState,
                    BillingPostalCode,
                    BillingCountry,
                    Description,
                    CreatedDate,
                    LastModifiedDate
                FROM Account
                WHERE Id = :request.accountId
                LIMIT 1
            ];
            
            if (accounts.isEmpty()) {
                AccountLookupResult errorResult = new AccountLookupResult();
                errorResult.success = false;
                errorResult.message = 'Account not found with ID: ' + request.accountId;
                results.add(errorResult);
                return results;
            }
            
            Account acc = accounts[0];
            
            // Build response
            AccountLookupResponse response = new AccountLookupResponse();
            response.accountId = acc.Id;
            response.accountName = acc.Name;
            response.accountType = acc.Type;
            response.industry = acc.Industry;
            response.phone = acc.Phone;
            response.website = acc.Website;
            response.annualRevenue = acc.AnnualRevenue;
            response.numberOfEmployees = acc.NumberOfEmployees;
            response.rating = acc.Rating;
            response.accountSource = acc.AccountSource;
            response.ownerName = acc.Owner.Name;
            response.ownerId = acc.OwnerId;
            response.billingStreet = acc.BillingStreet;
            response.billingCity = acc.BillingCity;
            response.billingState = acc.BillingState;
            response.billingPostalCode = acc.BillingPostalCode;
            response.billingCountry = acc.BillingCountry;
            response.description = acc.Description;
            response.createdDate = acc.CreatedDate != null ? acc.CreatedDate.format() : null;
            response.lastModifiedDate = acc.LastModifiedDate != null ? acc.LastModifiedDate.format() : null;
            
            // Create success result
            AccountLookupResult result = new AccountLookupResult();
            result.success = true;
            result.message = 'Account details retrieved successfully';
            result.response = response;
            results.add(result);
            
        } catch (QueryException e) {
            AccountLookupResult errorResult = new AccountLookupResult();
            errorResult.success = false;
            errorResult.message = 'Error querying account: ' + e.getMessage();
            results.add(errorResult);
        } catch (Exception e) {
            AccountLookupResult errorResult = new AccountLookupResult();
            errorResult.success = false;
            errorResult.message = 'Unexpected error: ' + e.getMessage();
            results.add(errorResult);
        }
        
        return results;
    }
    
    /**
     * Wrapper class for invocable input
     */
    global class AccountLookupWrapper {
        @InvocableVariable(label='Account Lookup Request' description='Account ID to lookup' required=true)
        global AccountLookupRequest request;
    }
    
    /**
     * Wrapper class for invocable output
     */
    global class AccountLookupResult {
        @InvocableVariable(label='Success' description='Indicates if the operation was successful')
        global Boolean success;
        
        @InvocableVariable(label='Message' description='Success or error message')
        global String message;
        
        @InvocableVariable(label='Account Details' description='Detailed account information')
        global AccountLookupResponse response;
    }
}