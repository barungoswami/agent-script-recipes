public with sharing class EE_CaseManagerController {
  @InvocableMethod(
        label='EEIS Case Status'
        description='Return Case Status, when user asks for it, for example user can ask what is the status of the case 100'
    )
    public static List<String> getStatus(List<String> casenumber) {
        // Retrieve case status by casenumber for which the request has been made by user or else return a error message
        List<Case> cases = [SELECT Id, Status FROM Case WHERE CaseNumber= :casenumber[0] LIMIT 1];
        if(cases.size()>0){
            return new List<String>{cases[0].status};
        }else
        {
            return new List<String>{'Case Number is not valid'};
        }
    }
}