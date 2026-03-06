import { api, LightningElement, wire } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import ACCOUNT_OBJECT from '@salesforce/schema/Account';

/**
 * Record form component for creating/editing Account records
 * Uses lightning-record-edit-form and lightning-input-field
 */
export default class AccountRecordForm extends LightningElement {
    @api
    get readOnly() {
        return this._readOnly;
    }
    set readOnly(value) {
        this._readOnly = value;
    }
    _readOnly = false;

    @api
    get value() {
        return this._value;
    }
    set value(value) {
        this._value = value;
        if (value) {
            this.accountId = value.accountId || null;
            this.loadFormData(value);
        }
    }
    _value;

    accountObject = ACCOUNT_OBJECT;
    accountId = null;
    isLoading = false;
    
    // Form mode
    isEditMode = false;
    
    // Wire account object info to get record type
    @wire(getObjectInfo, { objectApiName: ACCOUNT_OBJECT })
    accountInfo;

    loadFormData(data) {
        if (data.accountId) {
            this.accountId = data.accountId;
            this.isEditMode = true;
        } else {
            this.accountId = null;
            this.isEditMode = false;
        }
    }

    handleSuccess(event) {
        const recordId = event.detail.id;
        this.accountId = recordId;
        
        // Dispatch success toast
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Success',
                message: this.isEditMode ? 'Account updated successfully' : 'Account created successfully',
                variant: 'success'
            })
        );

        // Dispatch value change with the created/updated record ID
        const formValue = {
            accountId: recordId,
            success: true,
            message: this.isEditMode ? 'Account updated' : 'Account created'
        };

        this.dispatchEvent(new CustomEvent('valuechange', {
            detail: {
                value: formValue
            }
        }));
    }

    handleError(event) {
        const errorMessage = event.detail.message || 'Unknown error';
        
        this.dispatchEvent(
            new ShowToastEvent({
                title: 'Error',
                message: errorMessage,
                variant: 'error'
            })
        );
    }

    handleSubmit(event) {
        event.preventDefault();
        this.isLoading = true;
        
        const fields = event.detail.fields;
        
        // Submit the form
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }

    handleLoad() {
        this.isLoading = false;
    }

    handleReset() {
        const inputFields = this.template.querySelectorAll('lightning-input-field');
        if (inputFields) {
            inputFields.forEach(field => {
                field.reset();
            });
        }
    }

    get formTitle() {
        return this.isEditMode ? 'Edit Facility' : 'Create New Facility';
    }

    get formIcon() {
        return this.isEditMode ? 'utility:edit' : 'utility:add';
    }

    get submitButtonLabel() {
        return this.isEditMode ? 'Update Account' : 'Create Facility';
    }
}