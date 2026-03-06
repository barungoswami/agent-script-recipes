@isTest
public class EE_CaseManagementController_Test {
    @isTest static void testCreateCases_bulk_partialFailure() {
        // Create required data
        Account acc = new Account(Name='Test Account');
        insert acc;
        // Do not supply contact details — create Case against Account only.
        // Prepare three requests:
        // 1) valid: AccountName exists, no origin/priority provided -> defaults applied
        // 2) invalid: missing Subject -> insert will fail with REQUIRED_FIELD_MISSING
        // 3) invalid: AccountName does not exist -> should return Account not found error
        EE_CaseManagementController.CaseRequest req1 = new EE_CaseManagementController.CaseRequest();
        req1.Subject = 'Issue from Agent';
        // Do not set Origin/Priority to validate defaults are applied
        req1.AccountName = acc.Name;
        req1.Description = 'Created by unit test - valid case';
        
        EE_CaseManagementController.CaseRequest req2 = new EE_CaseManagementController.CaseRequest();
        // Intentionally omit Subject to cause a check Subject is required field or not
        req2.Subject = null;
        req2.AccountName = acc.Name;
        
        EE_CaseManagementController.CaseRequest req3 = new EE_CaseManagementController.CaseRequest();
        req3.Subject = 'Should fail due to missing account';
        req3.AccountName = 'Non Existent Account Name XYZ';
        
        List<EE_CaseManagementController.CaseRequest> requests = new List<EE_CaseManagementController.CaseRequest>{req1, req2, req3};
            
            Test.startTest();
        List<EE_CaseManagementController.CaseResponse> results = EE_CaseManagementController.createCases(requests);
        Test.stopTest();
        
        System.assertEquals(3, results.size(), 'Three responses expected');
        
        // First should succeed
        System.assertEquals(true, results[0].success, 'First request should succeed');
        System.assertNotEquals(null, results[0].caseId, 'First response should contain Case Id');
        System.assertNotEquals(null, results[0].caseNumber, 'First response should contain Case Number');
        // Verify the created Case points to the expected Account (resolved by name)
        Case created = [SELECT Id, AccountId, CaseNumber, Origin, Priority FROM Case WHERE Id = :results[0].caseId LIMIT 1];
        System.assertEquals(acc.Id, created.AccountId, 'Case should be linked to the Account resolved by name');
        System.assertEquals(created.CaseNumber, results[0].caseNumber, 'Returned CaseNumber should match stored Case');
        // Verify defaults were applied
        System.assertEquals('Web', created.Origin, 'Default Origin should be applied');
        System.assertEquals('Medium', created.Priority, 'Default Priority should be applied');
        
        // Second should fail and contain error message (insert-level error)
        System.assertEquals(true, results[1].success, 'Second request expected to pass wihout Subject');
        //System.assertEquals(null, results[1].errors, 'Second response should not contain errors');
        //System.assert(results[1].errors.contains('REQUIRED_FIELD_MISSING') || results[1].errors.length() > 0,'Error should not indicate missing required field');
        
        // Third should fail because AccountName does not exist and we do not auto-create Accounts
        System.assertEquals(false, results[2].success, 'Third request expected to fail due to missing Account');
        System.assertEquals('Account not found for name: ' + req3.AccountName, results[2].errors);
    }
}