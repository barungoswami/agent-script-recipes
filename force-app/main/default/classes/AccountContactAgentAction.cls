/**
 * Agent Action to retrieve accounts with related contacts
 * Returns data for the Account Contact Accordion Custom Lightning Type
 */
global with sharing class AccountContactAgentAction {
    
    /**
     * Retrieves accounts with their related contacts
     * 
     * @param accountType - Type of account filter (optional)
     * @param industry - Industry filter (optional)
     * @param minContacts - Minimum number of contacts (optional)
     * @param maxRecords - Maximum number of accounts to return (default: 10)
     * @return AccountContactResponse wrapper with account and contact data
     */
    @InvocableMethod(label='Get Accounts with Contacts' description='Retrieves accounts and their related contacts' category='Agent Actions')
    global static List<AccountContactResponse> getAccountsWithContacts(List<AccountContactRequest> requests) {
        List<AccountContactResponse> results = new List<AccountContactResponse>();
        
        if (requests == null || requests.isEmpty()) {
            return results;
        }
        
        AccountContactRequest request = requests[0];
        
        // Build dynamic SOQL query for accounts
        String accountQuery = 'SELECT Id, Name, Type, Industry, Phone, Website, ' +
                              'AnnualRevenue, NumberOfEmployees, BillingCity, BillingState, ' +
                              'BillingCountry, Rating, ' +
                              '(SELECT Id, FirstName, LastName, Email, Phone, MobilePhone, ' +
                              'Title, Department, Birthdate, MailingCity, MailingState, MailingCountry ' +
                              'FROM Contacts ORDER BY LastName) ' +
                              'FROM Account WHERE Id != null';
        
        // Add filters
        String accountType = request.accountType;
        String industry = request.industry;
        
        if (String.isNotBlank(accountType)) {
            accountQuery += ' AND Type = :accountType';
        }
        
        if (String.isNotBlank(industry)) {
            accountQuery += ' AND Industry = :industry';
        }
        
        // Add ordering and limit
        accountQuery += ' ORDER BY Name ASC';
        
        Integer maxRecords = request.maxRecords != null && request.maxRecords > 0 
                             ? request.maxRecords 
                             : 10;
        accountQuery += ' LIMIT :maxRecords';
        
        try {
            // Execute query
            List<Account> accounts = Database.query(accountQuery);
            
            // Convert to AccountContactList wrapper
            AccountContactResponse response = new AccountContactResponse();
            AccountContactList accountContactList = response.result;
            Integer totalContactCount = 0;
            
            // Transform Account SObjects to AccountWithContacts
            for (Account acc : accounts) {
                AccountWithContacts accData = new AccountWithContacts(
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
                    acc.Rating
                );
                
                // Transform contacts
                for (Contact con : acc.Contacts) {
                    ContactData contactData = new ContactData(
                        con.Id,
                        con.FirstName,
                        con.LastName,
                        con.Email,
                        con.Phone,
                        con.MobilePhone,
                        con.Title,
                        con.Department,
                        con.Birthdate,
                        con.MailingCity,
                        con.MailingState,
                        con.MailingCountry
                    );
                    accData.contacts.add(contactData);
                    totalContactCount++;
                }
                
                accData.contactCount = accData.contacts.size();
                
                // Apply minimum contacts filter if specified
                Integer minContacts = request.minContacts != null ? request.minContacts : 0;
                if (accData.contactCount >= minContacts) {
                    accountContactList.accounts.add(accData);
                }
            }
            
            accountContactList.totalAccounts = accountContactList.accounts.size();
            accountContactList.totalContacts = totalContactCount;
            
            // Set message
            if (accountContactList.totalAccounts == 0) {
                accountContactList.message = 'No accounts found matching the criteria.';
            } else {
                accountContactList.message = 'Found ' + accountContactList.totalAccounts + 
                                            ' account' + (accountContactList.totalAccounts != 1 ? 's' : '') +
                                            ' with ' + accountContactList.totalContacts + 
                                            ' contact' + (accountContactList.totalContacts != 1 ? 's' : '');
            }
            
            results.add(response);
            
        } catch (Exception e) {
            // Handle errors gracefully
            AccountContactResponse errorResponse = new AccountContactResponse();
            AccountContactList errorList = errorResponse.result;
            errorList.accounts = new List<AccountWithContacts>();
            errorList.totalAccounts = 0;
            errorList.totalContacts = 0;
            errorList.message = 'Error retrieving accounts: ' + e.getMessage();
            results.add(errorResponse);
        }
        
        return results;
    }
    
    /**
     * Output wrapper class for the invocable method
     */
    global class AccountContactResponse {
        @InvocableVariable(label='Account Contact List' description='List of accounts with related contacts')
        global AccountContactList result;
        
        global AccountContactResponse() {
            this.result = new AccountContactList();
        }
    }
    
    /**
     * Input wrapper class for the invocable method
     */
    global class AccountContactRequest {
        @InvocableVariable(label='Account Type' description='Filter by account type (e.g., Customer, Prospect)')
        global String accountType;
        
        @InvocableVariable(label='Industry' description='Filter by industry')
        global String industry;
        
        @InvocableVariable(label='Minimum Contacts' description='Minimum number of contacts per account')
        global Integer minContacts;
        
        @InvocableVariable(label='Max Records' description='Maximum number of accounts to return (default: 10)')
        global Integer maxRecords;
    }
}