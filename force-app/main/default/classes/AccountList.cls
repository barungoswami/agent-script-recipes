/**
 * Wrapper class for Account List
 * Used with Custom Lightning Type to display accounts in a data table
 */
@JsonAccess(serializable='always' deserializable='always')
global class AccountList {
    
    @AuraEnabled
    global List<AccountData> accounts;
    
    @AuraEnabled
    global Integer totalRecords;
    
    @AuraEnabled
    global String message;
}