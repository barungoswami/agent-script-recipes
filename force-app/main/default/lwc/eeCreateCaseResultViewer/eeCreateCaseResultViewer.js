import { LightningElement,api } from 'lwc';

export default class EeCreateCaseResultViewer extends LightningElement {
 @api recordId; // Public property to receive the record ID from the parent

 @api agentActionOutput; // The data from the Apex class is passed here
 get caseNumber() {
        // Access the caseNumber from the first item in the collection
        if (this.agentActionOutput && this.agentActionOutput.collection && this.agentActionOutput.collection.length > 0) {
            return this.agentActionOutput.collection[0].CaseNumber;
        }
        return 'N/A';
    }

get caseId() {
        if (this.agentActionOutput && this.agentActionOutput.collection && this.agentActionOutput.collection.length > 0) {
            return this.agentActionOutput.collection[0].CaseID;
        }
        return null;
    }
}