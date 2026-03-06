/**
 * Request model for Account record form
 * Used as INPUT with Custom Lightning Type (editor)
 */
@JsonAccess(serializable='always' deserializable='always')
global class AccountFormRequest {
    
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
    global String shippingStreet;
    
    @AuraEnabled
    global String shippingCity;
    
    @AuraEnabled
    global String shippingState;
    
    @AuraEnabled
    global String shippingPostalCode;
    
    @AuraEnabled
    global String shippingCountry;
    
    @AuraEnabled
    global String description;
    
    @AuraEnabled
    global String rating;
    
    @AuraEnabled
    global String accountSource;
    
    @AuraEnabled
    global String sla;
    
    global AccountFormRequest() {
        // Default constructor
    }
}