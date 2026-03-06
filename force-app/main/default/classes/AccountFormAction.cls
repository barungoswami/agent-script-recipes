/**
 * Agent action for creating or updating Account records
 * Used with accountRecordForm Custom Lightning Type
 */
global with sharing class AccountFormAction {
    
    /**
     * Create or update an Account record
     * @param requests List of AccountFormWrapper containing the request data
     * @return List of AccountFormResponse wrapper containing results
     */
    @InvocableMethod(
        label='Account Form Action'
        description='Creates or updates an Account record with the provided information'
        category='Account'
    )
    global static List<AccountFormResponse> processAccountForm(List<AccountFormWrapper> requests) {
        List<AccountFormResponse> responses = new List<AccountFormResponse>();
        
        if (requests == null || requests.isEmpty()) {
            AccountFormResponse errorResponse = new AccountFormResponse();
            errorResponse.success = false;
            errorResponse.message = 'No account data provided';
            responses.add(errorResponse);
            return responses;
        }
        
        AccountFormRequest request = requests[0].request;
        
        try {
            Account acc;
            Boolean isUpdate = false;
            
            // Check if we're updating an existing record
            if (String.isNotBlank(request.accountId)) {
                List<Account> existingAccounts = [
                    SELECT Id 
                    FROM Account 
                    WHERE Id = :request.accountId 
                    LIMIT 1
                ];
                
                if (!existingAccounts.isEmpty()) {
                    acc = existingAccounts[0];
                    isUpdate = true;
                } else {
                    acc = new Account();
                }
            } else {
                acc = new Account();
            }
            
            // Map request fields to Account object
            if (String.isNotBlank(request.accountName)) {
                acc.Name = request.accountName;
            }
            if (String.isNotBlank(request.accountType)) {
                acc.Type = request.accountType;
            }
            if (String.isNotBlank(request.industry)) {
                acc.Industry = request.industry;
            }
            if (String.isNotBlank(request.phone)) {
                acc.Phone = request.phone;
            }
            if (String.isNotBlank(request.website)) {
                acc.Website = request.website;
            }
            if (request.annualRevenue != null) {
                acc.AnnualRevenue = request.annualRevenue;
            }
            if (request.numberOfEmployees != null) {
                acc.NumberOfEmployees = request.numberOfEmployees;
            }
            
            // Billing Address
            if (String.isNotBlank(request.billingStreet)) {
                acc.BillingStreet = request.billingStreet;
            }
            if (String.isNotBlank(request.billingCity)) {
                acc.BillingCity = request.billingCity;
            }
            if (String.isNotBlank(request.billingState)) {
                acc.BillingState = request.billingState;
            }
            if (String.isNotBlank(request.billingPostalCode)) {
                acc.BillingPostalCode = request.billingPostalCode;
            }
            if (String.isNotBlank(request.billingCountry)) {
                acc.BillingCountry = request.billingCountry;
            }
            
            // Shipping Address
            if (String.isNotBlank(request.shippingStreet)) {
                acc.ShippingStreet = request.shippingStreet;
            }
            if (String.isNotBlank(request.shippingCity)) {
                acc.ShippingCity = request.shippingCity;
            }
            if (String.isNotBlank(request.shippingState)) {
                acc.ShippingState = request.shippingState;
            }
            if (String.isNotBlank(request.shippingPostalCode)) {
                acc.ShippingPostalCode = request.shippingPostalCode;
            }
            if (String.isNotBlank(request.shippingCountry)) {
                acc.ShippingCountry = request.shippingCountry;
            }
            
            // Additional fields
            if (String.isNotBlank(request.description)) {
                acc.Description = request.description;
            }
            if (String.isNotBlank(request.rating)) {
                acc.Rating = request.rating;
            }
            if (String.isNotBlank(request.accountSource)) {
                acc.AccountSource = request.accountSource;
            }
            if (String.isNotBlank(request.sla)) {
                acc.SLA__c = request.sla;
            }
            
            // Perform DML
            if (isUpdate) {
                update acc;
            } else {
                insert acc;
            }
            
            // Create success response
            AccountFormResponse response = new AccountFormResponse();
            response.success = true;
            response.accountId = acc.Id;
            response.message = isUpdate ? 
                'Account updated successfully: ' + acc.Name : 
                'Account created successfully: ' + acc.Name;
            responses.add(response);
            
        } catch (DmlException e) {
            AccountFormResponse errorResponse = new AccountFormResponse();
            errorResponse.success = false;
            errorResponse.message = 'Error saving account: ' + e.getMessage();
            responses.add(errorResponse);
        } catch (Exception e) {
            AccountFormResponse errorResponse = new AccountFormResponse();
            errorResponse.success = false;
            errorResponse.message = 'Unexpected error: ' + e.getMessage();
            responses.add(errorResponse);
        }
        
        return responses;
    }
    
    /**
     * Wrapper class for invocable input
     */
    global class AccountFormWrapper {
        @InvocableVariable(label='Account Form Request' description='Account form data' required=true)
        global AccountFormRequest request;
    }
    
    /**
     * Wrapper class for action response
     */
    global class AccountFormResponse {
        @InvocableVariable(label='Success' description='Indicates if the operation was successful')
        global Boolean success;
        
        @InvocableVariable(label='Account ID' description='ID of the created or updated account')
        global String accountId;
        
        @InvocableVariable(label='Message' description='Success or error message')
        global String message;
    }
}