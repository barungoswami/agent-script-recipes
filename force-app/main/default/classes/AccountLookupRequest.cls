/**
 * Request model for Account Lookup Custom Lightning Type
 * Used as INPUT with lightning-record-picker
 */
@JsonAccess(serializable='always' deserializable='always')
global class AccountLookupRequest {
    
    @AuraEnabled
    global String accountId;
    
    @AuraEnabled
    global String accountName;
}