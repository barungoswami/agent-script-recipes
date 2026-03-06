/**
 * Contact data model for Custom Lightning Type
 * Represents individual contact information
 */
@JsonAccess(serializable='always' deserializable='always')
global class ContactData {
    
    @AuraEnabled
    global String contactId;
    
    @AuraEnabled
    global String firstName;
    
    @AuraEnabled
    global String lastName;
    
    @AuraEnabled
    global String fullName;
    
    @AuraEnabled
    global String email;
    
    @AuraEnabled
    global String phone;
    
    @AuraEnabled
    global String mobilePhone;
    
    @AuraEnabled
    global String title;
    
    @AuraEnabled
    global String department;
    
    @AuraEnabled
    global Date birthdate;
    
    @AuraEnabled
    global String mailingCity;
    
    @AuraEnabled
    global String mailingState;
    
    @AuraEnabled
    global String mailingCountry;
    
    global ContactData(String contactId, String firstName, String lastName, 
                      String email, String phone, String mobilePhone, 
                      String title, String department, Date birthdate,
                      String mailingCity, String mailingState, String mailingCountry) {
        this.contactId = contactId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.fullName = (firstName != null ? firstName + ' ' : '') + (lastName != null ? lastName : '');
        this.email = email;
        this.phone = phone;
        this.mobilePhone = mobilePhone;
        this.title = title;
        this.department = department;
        this.birthdate = birthdate;
        this.mailingCity = mailingCity;
        this.mailingState = mailingState;
        this.mailingCountry = mailingCountry;
    }
}