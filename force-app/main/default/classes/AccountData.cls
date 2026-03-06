/**
 * Account data model for Custom Lightning Type
 * Represents individual account information
 */
@JsonAccess(serializable='always' deserializable='always')
global class AccountData {
    
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
    global String billingCity;
    
    @AuraEnabled
    global String billingState;
    
    @AuraEnabled
    global String billingCountry;
    
    @AuraEnabled
    global String rating;
    
    @AuraEnabled
    global Date createdDate;
    
    global AccountData(String accountId, String accountName, String accountType, 
                      String industry, String phone, String website, 
                      Decimal annualRevenue, Integer numberOfEmployees, 
                      String billingCity, String billingState, String billingCountry,
                      String rating, Date createdDate) {
        this.accountId = accountId;
        this.accountName = accountName;
        this.accountType = accountType;
        this.industry = industry;
        this.phone = phone;
        this.website = website;
        this.annualRevenue = annualRevenue;
        this.numberOfEmployees = numberOfEmployees;
        this.billingCity = billingCity;
        this.billingState = billingState;
        this.billingCountry = billingCountry;
        this.rating = rating;
        this.createdDate = createdDate;
    }
}