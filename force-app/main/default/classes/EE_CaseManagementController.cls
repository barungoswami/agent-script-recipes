public with sharing class EE_CaseManagementController {
    // InputWrapper class to define the input parameters
    // Wrapper used by Flow Builder/Agent actions. Each field that should be
    // provided from the action must be marked with @InvocableVariable.
    public class CaseRequest{
        @InvocableVariable(label='Subject' description='Subject' required=true)
        public String Subject;
        
        // AccountName is required input from the caller; AccountId is resolved
        // internally by the action and therefore not accepted as input.
        @InvocableVariable(label='Facility Name' description='Account Name' required=true)
        public String AccountName;
        
        @InvocableVariable(label='Description')
        public String Description;
    }
    
    // Response wrapper returned per request so callers can correlate results
    public class CaseResponse{
        @InvocableVariable(label='Case Id')
        public Id caseId;
        
        @InvocableVariable(label='Case Number'description='Raised Case Number' required=true)
        public String caseNumber;
        
        @InvocableVariable(label='Success')
        public Boolean success;
        
        @InvocableVariable(label='Errors')
        public String errors;
    }
    
    // The invocable method that the Agentforce action calls
    @InvocableMethod(label='EEIS Create New Case' description='Creates a new Case record with user-provided information.')
    public static List<CaseResponse> createCases(List<CaseRequest> requests) {
        List<CaseResponse> responses = new List<CaseResponse>();
        
        if (requests == null || requests.isEmpty()) {
            return responses;
        }
        
        // Resolve Account names to Ids for requests that supplied AccountName but not AccountId.
        Map<String, Id> accountNameToId = new Map<String, Id>();
        Set<String> namesToResolve = new Set<String>();
        for (CaseRequest r : requests) {
            if (r.AccountName != null) {
                namesToResolve.add(r.AccountName);
            }
        }
        
        if (!namesToResolve.isEmpty()) {
            // Query existing accounts by Name. If multiple accounts have the same name,
            // this will pick one (last in iteration). If your org requires a different
            // matching strategy, update accordingly.
            for (Account a : [SELECT Id, Name FROM Account WHERE Name IN :namesToResolve]) {
                accountNameToId.put(a.Name, a.Id);
            }
            
            // IMPORTANT: Do NOT create missing Accounts. If an AccountName doesn't
            // resolve to an Account Id, we'll return an error for that request rather
            // than auto-creating an Account.
        }
        
        // Prepare SObjects to insert and pre-populate response placeholders.
        // We keep a parallel index map (insertResponseIndexes) so we can correlate
        // Database.insert results back to the original request order. If an
        // AccountName cannot be resolved to an Account Id (and no AccountId was
        // supplied), we return an error for that request and skip inserting the Case.
        List<Case> casesToInsert = new List<Case>();
        List<Integer> insertResponseIndexes = new List<Integer>();
        List<Id> successfulCaseIds = new List<Id>();
        for (Integer idx = 0; idx < requests.size(); idx++) {
            CaseRequest r = requests[idx];
            CaseResponse resp = new CaseResponse();
            
            // Resolve AccountId from the supplied AccountName. AccountId is not
            // accepted as input; it will be retrieved internally.
            Id acctIdToUse = null;
            if (r.AccountName != null) {
                if (accountNameToId.containsKey(r.AccountName)) {
                    acctIdToUse = accountNameToId.get(r.AccountName);
                } else {
                    // Account name not found - return an error for this request
                    resp.success = false;
                    resp.errors = 'Account not found for name: ' + r.AccountName;
                    responses.add(resp);
                    continue;
                }
            }
            
            // Build Case SObject for insertion
            Case c = new Case();
            c.Subject = r.Subject;
            // Do not set Origin, Priority, ContactId, or RecordTypeId here so the
            // org-level default values and assignment rules apply automatically.
            if (acctIdToUse != null) c.AccountId = acctIdToUse;
            if (r.Description != null) c.Description = r.Description;
            
            casesToInsert.add(c);
            insertResponseIndexes.add(idx);
            responses.add(resp); // placeholder; will be populated after insert
        }
        
        // Bulk insert with partial success allowed. This ensures bulkification and
        // that one bad record does not roll back the entire batch.
        if (!casesToInsert.isEmpty()) {
            Database.SaveResult[] results = Database.insert(casesToInsert, false);
            
            // Populate responses based on save results. Map each insert result back
            // to the original request using insertResponseIndexes.
            for (Integer i = 0; i < results.size(); i++) {
                Database.SaveResult sr = results[i];
                Integer respIdx = insertResponseIndexes[i];
                CaseResponse resp = responses[respIdx];
                if (sr.isSuccess()) {
                    resp.caseId = sr.getId();
                    successfulCaseIds.add(sr.getId());
                    resp.success = true;
                    resp.errors = null;
                } else {
                    resp.success = false;
                    String sb = '';
                    for (Database.Error e : sr.getErrors()) {
                        if (sb.length() > 0) sb += ' ';
                        sb += '[' + e.getStatusCode() + '] ' + e.getMessage();
                    }
                    resp.errors = sb.toString();
                }
            }
            
            // Query CaseNumber for successfully inserted Cases and map them back to responses
            if (!successfulCaseIds.isEmpty()) {
                Map<Id, Case> createdCases = new Map<Id, Case>([SELECT Id, CaseNumber FROM Case WHERE Id IN :successfulCaseIds]);
                for (CaseResponse r : responses) {
                    if (r.caseId != null && createdCases.containsKey(r.caseId)) {
                        r.caseNumber = createdCases.get(r.caseId).CaseNumber;
                    }
                }
            }
        }
        return responses;
    }
}