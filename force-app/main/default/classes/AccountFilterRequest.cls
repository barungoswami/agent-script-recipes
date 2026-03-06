/**
 * Request filter for account industry filtering
 * Used as INPUT with Custom Lightning Type (editor)
 */
@JsonAccess(serializable='always' deserializable='always')
global class AccountFilterRequest {
    
    @AuraEnabled
    global List<String> selectedIndustries;
    
    @AuraEnabled
    global Integer maxRecords;
    
    @AuraEnabled
    global String accountType;
    
    global AccountFilterRequest() {
        this.selectedIndustries = new List<String>();
        this.maxRecords = 50;
    }
}