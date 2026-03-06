/**
* @File Name : EE_CaseRecordCreatorAction.cls
* @Description : Create Case record with Account Lookup supply apex controller for Agentforce action through custom lightning type
* @Author : Barun Kumar Goswami
* @Last Modified By :arun Kumar Goswami
* @Last Modified On : December 15, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | December 11, 2025 |   | Initial Version
**/

global class EE_CaseRecordCreatorAction {

	// Wrapper class to define the input structure
	@JsonAccess(serializable='always' deserializable='always')
    global class CreateRecordInput {
        @InvocableVariable(label='Case Subject' description='Subject of the new case.' required=true)
        @AuraEnabled
        global String subject;
        @InvocableVariable(label='Case Description' description='Description of the new case.' required=true)
        @AuraEnabled
        global String description;
		@InvocableVariable(label='Facility Name' description='Name of the account associated with the case.' required=true)
        @AuraEnabled
        global String facilityname;
    }

    // Wrapper class to define the output structure
	@JsonAccess(serializable='always' deserializable='always')
    global class CreateRecordOutput {
        @InvocableVariable(label='Case ID' description='ID of the newly created case.' required=true)
        global String createdRecordId;
        @InvocableVariable(label='Case Number' description='Case Number of the newly created case.' required=true)
        public String createdCaseNumber;
        @InvocableVariable(required=true)
        global String statusMessage;
    }
    
    @InvocableMethod(label='EEIS Create Case Record' description='Creates a new case record via Agentforce.')
    global static List<CreateRecordOutput> createNewRecord(List<CreateRecordInput> inputs) {
        List<CreateRecordOutput> results = new List<CreateRecordOutput>();
        List<Case> recordsToCreate = new List<Case>();
        
        for (CreateRecordInput input : inputs) {
            // Find the Account ID using the provided facility name
            List<Account> accounts = [SELECT Id FROM Account WHERE Name = :input.facilityname LIMIT 1];

            if (!accounts.isEmpty()){
                Case newRecord = new Case(
                    AccountId = accounts[0].Id,
                    Subject = input.subject,
                    Description = input.description
                );
                recordsToCreate.add(newRecord);
            }
        }

        try {
            insert recordsToCreate;

            //Query the database to retrieve the auto-generated CaseNumber 
            // using the case Id.
            List<Case> insertedCase = [SELECT Id, CaseNumber FROM Case WHERE Id = :recordsToCreate[0].Id];

            for (Case record : insertedCase) {
                CreateRecordOutput output = new CreateRecordOutput();
                output.createdRecordId = record.Id;
                output.createdCaseNumber = record.CaseNumber;
                output.statusMessage = 'Record created successfully with Case Number: ' + record.CaseNumber;
                results.add(output);
            }
        } catch (DmlException e) {
            // Handle exceptions
            CreateRecordOutput output = new CreateRecordOutput();
            output.createdRecordId = null;
            output.createdCaseNumber = null;
            output.statusMessage = 'Error creating record: ' + e.getDmlMessage(0);
            results.add(output);
        }

        return results;
    }
}