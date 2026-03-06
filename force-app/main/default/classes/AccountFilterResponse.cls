/**
 * Response wrapper for filtered accounts
 * Used as OUTPUT with Custom Lightning Type (renderer)
 */
@JsonAccess(serializable='always' deserializable='always')
global class AccountFilterResponse {
    
    @AuraEnabled
    global List<AccountData> accounts;
    
    @AuraEnabled
    global Integer totalRecords;
    
    @AuraEnabled
    global List<String> appliedFilters;
    
    @AuraEnabled
    global String message;
    
    global AccountFilterResponse() {
        this.accounts = new List<AccountData>();
        this.appliedFilters = new List<String>();
        this.totalRecords = 0;
    }
}