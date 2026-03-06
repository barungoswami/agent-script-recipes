global with sharing class EE_ShowInputComplainForm {
    
    @InvocableMethod(label='EEIS Create Complain Not used' description='Creates a new Case record')
    global static List<ComplianResponse> complainresp(List<ComplainReq> compreq) {
        List<ComplianResponse> results = new List<ComplianResponse>();
        return results;  
    }
    
    global class ComplainReq {
        @InvocableVariable(required=true)
        global Complaindata compdata;
    } 
    
    global class Complaindata {
        @InvocableVariable(label='Facility Name' description='Facility Name' required=true)
        global String facilityName;
        @InvocableVariable(label='Subject' description='Subject' required=true)
        global String subject;
        @InvocableVariable(label='Description' description='Description' required=true)
        global String description;
    }
    
    global class ComplianResponse {
        @InvocableVariable
        global String message;
    }
}