/**
 * Response model for Account Lookup Custom Lightning Type
 * Used as OUTPUT to display account details
 */
@JsonAccess(serializable='always' deserializable='always')
global class AccountLookupResponse {
    
    @AuraEnabled
    global String accountId;
    
    @AuraEnabled
    global String accountName;
    
    @AuraEnabled
    global String accountType;
    
    @AuraEnabled
    global String industry;
    
    @AuraEnabled
    global String phone;
    
    @AuraEnabled
    global String website;
    
    @AuraEnabled
    global Decimal annualRevenue;
    
    @AuraEnabled
    global Integer numberOfEmployees;
    
    @AuraEnabled
    global String rating;
    
    @AuraEnabled
    global String accountSource;
    
    @AuraEnabled
    global String ownerName;
    
    @AuraEnabled
    global String ownerId;
    
    @AuraEnabled
    global String billingStreet;
    
    @AuraEnabled
    global String billingCity;
    
    @AuraEnabled
    global String billingState;
    
    @AuraEnabled
    global String billingPostalCode;
    
    @AuraEnabled
    global String billingCountry;
    
    @AuraEnabled
    global String description;
    
    @AuraEnabled
    global String createdDate;
    
    @AuraEnabled
    global String lastModifiedDate;
}