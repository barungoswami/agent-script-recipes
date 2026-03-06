/**
 * Wrapper class for list of accounts with contacts
 * Used with Custom Lightning Type accordion component
 */
@JsonAccess(serializable='always' deserializable='always')
global class AccountContactList {
    
    @AuraEnabled
    global List<AccountWithContacts> accounts;
    
    @AuraEnabled
    global Integer totalAccounts;
    
    @AuraEnabled
    global Integer totalContacts;
    
    @AuraEnabled
    global String message;
    
    global AccountContactList() {
        this.accounts = new List<AccountWithContacts>();
        this.totalAccounts = 0;
        this.totalContacts = 0;
    }
}