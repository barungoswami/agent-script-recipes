import { LightningElement,track,wire,api } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import CASE_NUMBER_FIELD from '@salesforce/schema/Case.CaseNumber';
const FIELDS = [CASE_NUMBER_FIELD];

export default class EeCreateCase extends LightningElement {
    selectedAccountId; //variable to receive the selected account ID from the child custom reusable lookup component
    @track createdRecordId = ''; // Variable to hold the new record ID
    @track caseNumber='';

    @api params = []; //parameters which needs to be sent from the enhanced chat message with case input fields e.g. subject, description, facility id etc.
    caseSubject = '';
    caseDescription = '';
    facilityId = '';

    //wired method to retrieve the casenumber from the created case record id
    @wire(getRecord, { recordId: '$createdRecordId', fields: FIELDS })
    wiredCase({ error, data }) {
        if (data) {
            this.caseNumber = getFieldValue(data, CASE_NUMBER_FIELD);
        } else if (error) {
            console.error('Error fetching Case:', error);
            this.caseNumber = 'Error';
        }
    }

    handleCaseSubjectChange( event ) {
        this.caseSubject = event.target.value;
    }

    handleCaseDescriptionChange( event ) {
        this.caseDescription = event.target.value;
    }

    handleValueSelectedOnAccount(event) {
        this.selectedAccountId = event.detail;
        //console.log('Selected Record Details as retrived from Parent Component>>',JSON.stringify(event.detail));
        console.log('Selected Account Record Id>>',event.detail);
        // Fire an event to parent component
        /*this.dispatchEvent(
            new CustomEvent('valueselected', {
                detail: { recordId: this.selectedAccountId}
            })
        )*/
    }

    // Custom submit handler to include the Account ID
    handleCaseSubmit(event) {
        event.preventDefault(); // Stop the form from submitting normally
        const fields = event.detail.fields;

        // Manually add the selected AccountId to the fields object
        if (this.selectedAccountId) {
            fields.AccountId = this.selectedAccountId;
        }

        // Submit the form with the modified fields
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleSuccess(event){
        // Get the ID of the newly created record from the event details
        this.createdRecordId = event.detail.id;

        this.dispatchEvent( new CustomEvent(
                'casecomplete', 
                { detail: {caseNumber:caseNumber} }
            ) );
    }
}